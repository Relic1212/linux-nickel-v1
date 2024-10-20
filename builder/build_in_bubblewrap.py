import json

try:
    from builder import bubblewrap, hashes, util_functions, dirpaths,fetcher
except ModuleNotFoundError:
    import bubblewrap, hashes, util_functions, dirpaths,fetcher

import os


def get_src_dir(src_uri, src_uri_sha256sum) -> str:
    return dirpaths.get_basedir() + "/" + src_uri_sha256sum + "-src"


def find_extrafile(name, sha256sum) -> str:
    for root, directory, file in os.walk("pkgs"):
        for f in directory + file:
            p = os.path.join(root, f)
            if not (os.path.exists(p)):
                raise Exception()
            if f == name:
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
    workdir0 = "build/" + drv["hash"] + "-build"
    workdir = "build/" + hashes.str_to_sha256sum(json.dumps(drv["manifest"])) + "-build"

    if workdir0 != workdir:
        print("workdir ", workdir)
        print("workdir0", workdir0)
        raise Exception
    return workdir


def build(h,pkg_drvs: str) -> None:

    # h=hash
    # drv_s=pkgs[hash]

    drv_s=pkg_drvs[h]
    drv = json.loads(drv_s)

    base_build_dir = dirpaths.get_basedir() + h + "-build"
    status_file = base_build_dir + "/0.txt"
    if os.path.isfile(status_file):
        return
    manifest = drv["manifest"]
    src_uri = manifest["src_uri"]
    src_uri_sha256sum = manifest["src_uri_sha256sum"]
    fetcher.fetch(src_uri, src_uri_sha256sum)


    os.makedirs(base_build_dir + "/build")
    with open(base_build_dir + "/manifest.json", "w") as f:
        json.dump(manifest, f)
    os.makedirs(base_build_dir + "/sysroot", exist_ok=True)
    os.makedirs(base_build_dir + "/destdir", exist_ok=True)
    os.makedirs(base_build_dir + "/src")

    os.makedirs(f"{base_build_dir}/unpacked")
    os.makedirs(f"{base_build_dir}/unpacked_extra")

    os.makedirs(f"{base_build_dir}/patches")
    os.makedirs(f"{base_build_dir}/files")

    extrafiles = manifest["extra_files"]
    for ef_data in extrafiles:
        hash = ef_data["sha256sum"]
        file = ef_data["file"]
        fp = find_extrafile(name=file, sha256sum=hash)
        if os.path.isfile(fp):
            cmd = f"cp {fp} {base_build_dir}/files/"
        elif os.path.isdir(fp):
            cmd = f"cp -r {fp} {base_build_dir}/files/"
        else:
            print(f"ERROR {fp} is neither a file nor a directory")
            raise Exception

        s = os.system(cmd)
        if s != 0:
            print(f"ERROR: cmd {cmd} failed with status {s}")

    patches = manifest["patches"]

    for p_data in patches:
        hash = p_data["sha256sum"]
        file = p_data["file"]
        fp = find_extrafile(name=file, sha256sum=hash)
        if os.path.isfile(fp):
            cmd = f"cp {fp} {base_build_dir}/patches/"
        elif os.path.isdir(fp):
            cmd = f"cp -r {fp} {base_build_dir}/patches/"
        else:
            print(f"ERROR {fp} is neither a file nor a directory")
            raise Exception

        s = os.system(cmd)
        if s != 0:
            print(f"ERROR: cmd {cmd} failed with status {s}")

    if src_uri != "":
        u = (
            get_src_dir(src_uri=src_uri, src_uri_sha256sum=src_uri_sha256sum)
            + "/unpacked"
        )

        print(f"looking for unpacked sources in {u}")
        for f in os.listdir(u):
            print(f"copying {f} to  {base_build_dir}/unpacked ")
            os.system(f"cp -r {u}/{f} {base_build_dir}/unpacked/ ")

    for extra_src in manifest["extra_src"]:
        src_uri = extra_src["src_uri"]
        src_uri_sha256sum = extra_src["src_uri_sha256sum"]
        dest = extra_src["dest"]
        src_dir = get_src_dir(src_uri, src_uri_sha256sum)

        filenames = os.listdir(src_dir + "/unpacked")
        if len(filenames) != 1:
            print(f"ERROR for dest={dest}, not precisely 1 path")
            raise Exception
        filename = filenames[0]
        filepath = src_dir + "/unpacked/" + filename

        full_dest = f"{base_build_dir}/unpacked_extra/" + dest

        os.makedirs(full_dest)

        cmd = f"cp {filepath} { full_dest + "/" + filename}"
        s = os.system(cmd)
        if s != 0:
            print(f"ERROR: {cmd} failed")
            raise Exception

    build_command = manifest["command"]
    util_functions.write_script(
        script_content=build_command, script_filepath=base_build_dir + "/build.sh"
    )

    ropaths = ["unpacked", "unpacked_extra", "files", "patches", "build.sh"]
    args = util_functions.list_to_string(
        [f" --ro-bind {base_build_dir}/{d} /tmp/workdir/{d} \\\n" for d in ropaths]
    )

    rwdirs = ["src", "build", "destdir"]
    args += util_functions.list_to_string(
        [f" --bind {base_build_dir}/{d} /tmp/workdir/{d} \\\n" for d in rwdirs]
    )

    sandboxed = manifest["sandboxed"]
    uses_ccache = manifest["uses_ccache"]
    if sandboxed:
        sysroot = base_build_dir + "/sysroot/"
        for d in ropaths + rwdirs + ["/tmp", "/run", "/proc", "/sys", "/dev"]:
            os.makedirs(sysroot + "/" + d, exist_ok=True)
        os.environ.clear()
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
                    cmd = f"ln -s /usr/bin/ccache {compiler} "
                    dir = sysroot + "/usr/lib/ccache"
                    util_functions.run_in_directory(directory=dir, cmd=cmd)

            os.environ["CCACHE_DIR"] = "/tmp/ccache"
            args += " --bind build/ccache /tmp/ccache"

        os.environ["PATH"] = path
        os.environ["HOME"] = "/"

    else:
        sysroot = "/"
        args += f" --ro-bind {base_build_dir}/sysroot /tmp/workdir/sysroot \\\n"

        try:
            ce = os.environ.get("CCACHE_DIR")
            if ce:
                if ce != "/tmp/ccache":
                    args += f" --bind {ce} {ce} "
        except:
            pass

    args += " /tmp/workdir/build.sh"

    status = bubblewrap.run_in_bwrap_chroot(sysroot=sysroot, extra_bwrap_args=args)

    if status != 0:
        print(f"ERROR {status}")
        raise Exception


def prepare_sysroot(workdir: str, buildinputs: dict):
    for bi in buildinputs:
        hash = bi["name"]
        other_root = f"build/{hash}-build/destdir"
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
