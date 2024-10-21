import json
import subprocess

try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher
except ModuleNotFoundError:
    import bubblewrap, hashes, util_functions, dirpaths, fetcher

import os


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


def build(h, pkg_drvs: str) -> None:

    # h=hash
    # drv_s=pkgs[hash]

    drv_s = pkg_drvs[h]
    drv = json.loads(drv_s)

    workdir = dirpaths.get_basedir() + "/" + h + "-workdir"
    status_file = workdir + "/0.txt"
    if os.path.isfile(status_file):
        return
    subprocess.run(["rm", "-rf", workdir], check=True)
    os.makedirs(workdir + "/build")
    with open(workdir + "/drv.json", "w", encoding="utf-8") as f:
        json.dump(drv, f)
    os.makedirs(workdir + "/sysroot", exist_ok=True)
    os.makedirs(workdir + "/out/destdir", exist_ok=True)
    os.makedirs(workdir + "/src")

    os.makedirs(f"{workdir}/packed")

    os.makedirs(f"{workdir}/patches")
    os.makedirs(f"{workdir}/files")
    for bi_drv in drv["buildInputDrvs"]:
        build(h=bi_drv, pkg_drvs=pkg_drvs)
        bi_dest = dirpaths.get_basedir() + "/" + bi_drv + "-workdir/out/destdir"
        util_functions.copy_root(src=bi_dest, dest=workdir + "/sysroot")
    for si_drv in drv["sourceInputDrvs"]:
        dest = si_drv["dest"]
        si_h = si_drv["src"]
        full_dest = workdir + f"/packed/{si_h}"
        if dest != "":
            full_dest += f"/{dest}"
        # should not exist as workdir was deleted and si_h is unique
        os.makedirs(full_dest)
        si = pkg_drvs[si_h]
        fetcher.fetch_by_drv_string(si)
        copy_src(h=si_h, dest=full_dest)

    patch_drvs = drv["patchDrvs"]

    extra_file_drvs = drv["extraFileDrvs"]

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
                    cmd = ["ln, -s, /usr/bin/ccache", compiler]
                    directory = sysroot + "/usr/lib/ccache"
                    senv = {"PATH": path}
                    subprocess.run(cmd, cwd=directory, env=senv, check=True)

            os.environ["CCACHE_DIR"] = "/tmp/ccache"
            args += ["--bind", f"{dirpaths.get_basedir()}/ccache", "/tmp/ccache"]

        senv = {}
        senv["PATH"] = path
        senv["HOME"] = "/"

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

    bubblewrap.run_in_bwrap_chroot(sysroot=sysroot, extra_bwrap_args=args, env=senv)
    subprocess.run(["touch", status_file], check=True)


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
