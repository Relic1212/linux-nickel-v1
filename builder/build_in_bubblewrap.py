import json
import subprocess
import sys
import timeit 
import datetime

try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher
except ModuleNotFoundError:
    import bubblewrap, hashes, util_functions, dirpaths, fetcher

import os


class LogFile:
    def __init__(self, file_objects: str) -> None:
        self.file_objects = file_objects

    def write(self, obj):
        for f in self.file_objects:
            f.write(obj)


def get_src_dir(src_uri, src_uri_sha256sum) -> str:
    return dirpaths.get_basedir() + "/" + src_uri_sha256sum + "-src"


def find_extrafile(name, sha256sum, files_dir="") -> str:
    for root, directory, file in os.walk("pkgs"):
        for f in directory + file:
            p = os.path.join(root, f)
            if not (os.path.exists(p)):
                raise Exception()
            if (f == name) and (p.endswith(files_dir)):
                s = hashes.compute_file_or_dir_sha256sum(p)
                if s == sha256sum:
                    return p
    print("ERROR, could not find", name)
    raise Exception()


# def fetch_src(src_uri: str, src_uri_sha256sum: str) -> None:
#     src_dir = get_src_dir(src_uri, src_uri_sha256sum)
#     status_file = src_dir + "/0.txt"
#     if os.path.isfile(status_file):
#         return
#     if src_uri == "":
#         return

#     os.system(f"rm -rf {src_dir}")
#     os.makedirs(f"{src_dir}/unpacked")
#     if src_uri.startswith("http"):
#         cmd = f"wget {src_uri}"
#     else:
#         cmd = f"cp -r {os.path.realpath(src_uri)} ."
#     util_functions.run_in_directory(cmd=cmd, directory=f"{src_dir}/unpacked")

#     os.system(f"touch {status_file}")


def drv_to_workdir(drv: dict) -> str:
    """
    drv must be on the from
    {
        'manifest':<manifest>,
        'hash':<hash>
    }
    """
    workdir0 = "build/" + drv["hash"] + "-workdir"
    workdir = (
        "build/" + hashes.str_to_sha256sum(json.dumps(drv["manifest"])) + "-workdir"
    )

    if workdir0 != workdir:
        print("workdir ", workdir)
        print("workdir0", workdir0)
        raise Exception()
    return workdir


def copy_src(h, dest):
    src_dir = dirpaths.get_basedir() + "/" + h + "-src/packed/"
    cont = os.listdir(src_dir)
    if len(cont) != 1:
        raise Exception(f"{src_dir} does not contain exactly one item")
    src_p = src_dir + "/" + cont[0]
    subprocess.run(["cp", "-r", src_p, dest], check=True)


def run_and_get_lines(**kwargs):
    p = subprocess.Popen(**kwargs)
    for l in p.stdout.readline():
        yield l
        # yield {
        #     "type":"stdout",
        #   "line":l }
    # for l in p.stderr.readline():
    #     yield {
    #         "type":"stderr",
    #       "line":l }
    status = p.wait()
    if not status:
        raise subprocess.CalledProcessError(status, cmd=p.args)


def link_workdir(h, name):
    workdir = dirpaths.get_basedir() + "/" + h + "-workdir"



    os.makedirs(dirpaths.get_basedir() + "/tmp", exist_ok=True)
    subprocess.run(
        ["rm", "-f", dirpaths.get_basedir() + "/tmp/" + name], check=True
    )
    subprocess.run(
        [
            "ln",
            "-s",
            os.path.realpath(workdir),
            os.path.realpath(dirpaths.get_basedir()) + "/tmp/" + name,
        ],
        check=True,
    )


def build(h, pkg_drvs: str) -> None:

    # h=hash
    # drv_s=pkgs[hash]

    drv_s = pkg_drvs[h]
    drv = json.loads(drv_s)
    name=drv["name"]

    workdir = dirpaths.get_basedir() + "/" + h + "-workdir"
    status_file = workdir + "/0.txt"
    if os.path.isfile(status_file):
        link_workdir(h, name)

        return
    subprocess.run(["rm", "-rf", workdir], check=True)
    for bi_drv in drv["buildInputDrvs"]:
        build(h=bi_drv, pkg_drvs=pkg_drvs)
    for si_drv in drv["sourceInputDrvs"]:
        si_h = si_drv["src"]

        si = pkg_drvs[si_h]
        fetcher.fetch_by_drv_string(si)
    
    print(f"building {name}")

    os.makedirs(workdir + "/build")
    with open(workdir + "/drv.json", "w", encoding="utf-8") as f:
        json.dump(drv, f)
    os.makedirs(workdir + "/sysroot", exist_ok=True)
    os.makedirs(workdir + "/out/destdir", exist_ok=True)
    os.makedirs(workdir + "/src")
    with open(workdir + f"/pn-{name}","w",encoding="utf-8") as f:
        pass

    subprocess.run(["rm", "-f", dirpaths.get_basedir() + "/latest"], check=True)
    subprocess.run(
        [
            "ln",
            "-s",
            os.path.realpath(workdir),
            os.path.realpath(dirpaths.get_basedir()) + "/latest",
        ],
        check=True,
    )
    link_workdir(h, name)

    os.makedirs(f"{workdir}/packed")

    os.makedirs(f"{workdir}/patches")
    os.makedirs(f"{workdir}/files")

    for bi_drv in drv["buildInputDrvs"]:
        bi_dest = dirpaths.get_basedir() + "/" + bi_drv + "-workdir/out/destdir"
        
        print(f"copying from {bi_dest}/ to {workdir}/sysroot/")
        util_functions.copy_root(src=bi_dest + "/", dest=workdir + "/sysroot/")

    for si_drv in drv["sourceInputDrvs"]:
        dest = si_drv["dest"]
        si_h = si_drv["src"]
        full_dest = workdir + f"/packed/{si_h}"
        if dest != "":
            full_dest += f"/{dest}"
        # should not exist as workdir was deleted and si_h is unique
        os.makedirs(full_dest)
        si = pkg_drvs[si_h]
        copy_src(h=si_h, dest=full_dest)

    patch_drvs = drv["patchDrvs"]
    for pd in patch_drvs:
        patch_file = pd["file"]
        patch_sha256sum = pd["sha256sum"]
        pathc_uri = find_extrafile(patch_file, patch_sha256sum)
        patch_dest = f"{workdir}/patches/{patch_file}"
        if os.path.exists(patch_dest):
            raise FileExistsError(patch_dest)
        subprocess.run(["cp", pathc_uri, patch_dest], check=True)

    extra_file_drvs = drv["extraFileDrvs"]
    for ef in extra_file_drvs:
        ef_file = ef["file"]
        ef_sha256sum = ef["sha256sum"]
        ef_uri = find_extrafile(ef_file, ef_sha256sum)
        ef_dest = f"{workdir}/files/{ef_file}"
        if os.path.exists(ef_dest):
            raise FileExistsError(ef_dest)
        if os.path.isdir(ef_uri):
            ef_cp_cmd = ["cp","-r"]
        else:
            ef_cp_cmd = ["cp"]

        subprocess.run(ef_cp_cmd + [ef_uri, ef_dest], check=True)

    build_command = drv["scriptContent"]
    build_script_path = workdir + "/build.sh"
    with open(build_script_path, "w", encoding="utf-8") as f:
        f.write(build_command)
    subprocess.run(["chmod", "+x", build_script_path], check=True)

    ropaths = ["packed", "files", "patches", "build.sh"]
    args = []
    for ropath in ropaths:
        args += ["--ro-bind", f"{workdir}/{ropath}", f"/tmp/workdir/{ropath}"]

    rwpaths = ["src", "build", "out"]

    for rwpath in rwpaths:
        args += ["--bind", f"{workdir}/{rwpath}", f"/tmp/workdir/{rwpath}"]

    sandboxed = drv["buildInChroot"]
    uses_ccache = drv["enableCcache"]
    if sandboxed:
        sysroot = workdir + "/sysroot/"
        for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev"]:
            os.makedirs(sysroot + "/" + d, exist_ok=True)
        # os.environ.clear()

        path = "/usr/bin:/usr/sbin:/bin:/sbin"
        if uses_ccache:
            path = "/usr/lib/ccache:" + path
            for compiler in [
                "gcc",
                "cc",
                "clang",
                "g++",
                "clang++",
                "x86_64-pc-linux-musl-c++",
                "x86_64-pc-linux-musl-g++",
                "x86_64-pc-linux-musl-gcc",
            ]:
                if os.path.exists(sysroot + "/usr/bin/" + compiler):
                    cmd = ["ln", "-s", "/usr/bin/ccache", compiler]
                    directory = sysroot + "/usr/lib/ccache"
                    senv = {"PATH": os.getenv("PATH"), "HOME": "/"}
                    subprocess.run(cmd, cwd=directory, env=senv, check=True)

            os.environ["CCACHE_DIR"] = "/tmp/ccache"
            args += ["--bind", f"{dirpaths.get_basedir()}/ccache", "/tmp/ccache"]

        senv = {}
        senv["PATH"] = path
        senv["HOME"] = "/"
        if uses_ccache:
            senv["CCACHE_DIR"] = "/tmp/ccache"

    else:
        senv = os.environ.copy()
        sysroot = "/"
        args += ["--ro-bind", f"{workdir}/sysroot", "/tmp/workdir/sysroot"]

        try:
            ce = os.environ.get("CCACHE_DIR")
            if ce:
                if ce != "/tmp/ccache":
                    args += ["--bind", ce, ce]
        except:
            pass

    args += ["--chdir", "/tmp/workdir/build"]
    args += ["/tmp/workdir/build.sh"]

    t1=timeit.default_timer()
    with open(f"{workdir}/b.log", "a", encoding="utf-8") as f:
        with open(f"{workdir}/error.log", "a", encoding="utf-8") as f_error:
            # bubblewrap.run_in_bwrap_chroot(sysroot=sysroot, extra_bwrap_args=args, env=senv, stderr=errorfile,stdout=logfile)
            bwrap_wrap = bubblewrap.get_bwrap_wrap(
                sysroot=sysroot, extra_bwrap_args=args
            )
            chroot_string =( "#!/bin/sh\n" + ''.join ([s+" " for s in  bwrap_wrap])[: -1-len  ("/tmp/workdir/build.sh")] + "sh\n")

            with open(f"{workdir}/chroot.sh","w",encoding="utf-8") as f_chroot:
                f_chroot.write(chroot_string)
            subprocess.run(["chmod","+x",f"{workdir}/chroot.sh"],check=True)
                

            with subprocess.Popen(
                args=bwrap_wrap,
                env=senv,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                universal_newlines=True,
                text=True,
            ) as proc:
                for line in proc.stdout:
                    print(line, end="")
                    f.write(line)
        f.close()
        status = proc.returncode
        if status != 0:
            print("env =", senv)
            print(f"Failed to build {name}")
            raise subprocess.CalledProcessError(status, cmd=bwrap_wrap)
    subprocess.run(["touch", status_file], check=True)
    t2=timeit.default_timer()
    buildtime=datetime.timedelta(seconds=t2-t1)
    print(f"building {name} took {buildtime}")
    with open (dirpaths.get_basedir() + "/tmp/buildtimes.txt","a",encoding="utf-8") as f:
        f.write(f"{name}\t-\t{buildtime}\n")
    print(f"finished building {name}")


def prepare_sysroot(workdir: str, buildinputs: dict):
    for bi in buildinputs:
        h = bi["name"]
        other_root = f"build/{h}-workdir/out/destdir"
        print(f"copying from destdir: {other_root} \nto ")
        util_functions.copy_root(src=other_root, dest=workdir + "/" + bi["dir"])


def pkgs_to_stringdrvs(pkgs: dict) -> dict[str, dict[str, str]]:
    strings = {"pkgs": {}, "hashes": {}}
    for k in pkgs.keys():
        manifest = pkgs[k].get_manifest()
        hash = manifest["hash"]
        strings["pkgs"][k] = json.dumps(manifest)
        strings["hashes"][
            hash
        ] = k  # to build dependencies we need to be able to go hash -> name

    return strings


def build_package_from_drv(package_name, drvs):
    drv = json.loads(drvs["pkgs"][package_name])

    manifest = drv["manifest"]
    workdir = drv_to_workdir(drv)
    status_file = workdir + "/0.txt"
    link_cmd = f"ln -s $(realpath {workdir})   $(realpath ./build/tmp/{package_name})"

    if os.path.exists(f"build/tmp/{package_name}"):
        os.system(f"rm build/tmp/{package_name}")

    if os.path.isfile(status_file):
        print(f"{package_name} is already build in \n{workdir}")

        print(f"linking {link_cmd}")
        os.system(link_cmd)
        return
    # build deps
    print(f"manifest for {package_name} is")
    print(manifest)

    print("building", package_name)

    try:
        buildinputs = manifest["build_inputs"]
    except:
        print(manifest)
        print(manifest.keys())
        raise Exception

    for b in buildinputs:
        h = b["name"]
        name = drvs["hashes"][h]
        build_package_from_drv(package_name=name, drvs=drvs)

    os.system(f"rm -rf {workdir}")
    os.mkdir(workdir)
    os.system(link_cmd)

    madedirs = []
    for d in [dtmp["dir"] for dtmp in manifest["build_inputs"]]:
        if not d in madedirs:
            # print("d =",d,"madedirs =",madedirs)
            # print (f"making {workdir}/{d}")
            os.makedirs(f"{workdir}/{d}")
            madedirs.append(d)
    # copy deps
    prepare_sysroot(workdir=drv_to_workdir(drv), buildinputs=manifest["build_inputs"])

    # final build
    print("executing final build of", package_name)
    build(drv_s=drvs["pkgs"][package_name])
    os.system(f"touch {status_file}")
    print(f"build {package_name} in {workdir}")


def bf():
    import sys

    fp = sys.argv[1]
    with open(fp) as f:
        drv_s = f.read()
    build(drv_s)
