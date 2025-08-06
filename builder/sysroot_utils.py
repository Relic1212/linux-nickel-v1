import os
import subprocess
try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher
except ModuleNotFoundError:
    import bubblewrap
    import hashes
    import util_functions
    import dirpaths
    import fetcher


def prepare_sysroot(drv, workdir) -> list:
    bwrap_bi_drv_args = []
    if (drv["buildInChroot"]) and (drv['symlinkBuldInputs']):
        bwrap_bi_drv_args = ["--tmpfs", "/pkgs"]

    for bi_drv in drv["buildInputDrvs"]:
        bi_dest = dirpaths.get_basedir() + "/" + bi_drv + "-workdir/out/destdir"

        if (not drv["buildInChroot"]) or (not drv['symlinkBuldInputs']):
            print(f"copying from {bi_dest}/ to {workdir}/sysroot/")
            util_functions.copy_root(
                src=bi_dest + "/", dest=workdir + "/sysroot/")
            continue

        bi_dest_bwrap_args = bubblewrap.get_paths_from_sysroot(bi_dest)
        sysroot_dirs = bi_dest_bwrap_args['dirs']
        sysroot_files = bi_dest_bwrap_args['files']
        # all the dirs so the symlinks will work
        for bi_drv_dir in sysroot_dirs:
            dst = workdir + "/sysroot/" + bi_drv_dir

            if os.path.isdir(dst):
                continue
            # maybe it is better to reverse order anf just skip if it exists
            if os.path.exists(dst) or os.path.islink(dst):
                os.remove(dst)
            os.makedirs(dst)

        # create intentianlly broken symlink
        for sd in sysroot_files:
            link_source = "/pkgs/"+bi_drv + sd
            link_target = workdir + "/sysroot" + sd
            if os.path.exists(link_target) or os.path.islink(link_target):
                print(f"removing {link_target} to link")
                subprocess.run(["rm", "-rf", link_target], check=True)

            # print(f"linking {link_source} to {link_target}")
            subprocess.run(["ln", "-s", link_source, link_target], check=True)
        bwrap_bi_drv_args += ["--ro-bind", bi_dest, "/pkgs/" + bi_drv]

    return bwrap_bi_drv_args


def build_sysroot(drv_hash, build_inputs, uses_ccache):
    sysroot_drvdir = dirpaths.get_basedir() + f"/{drv_hash}-sysroot"
    if os.path.isfile(sysroot_drvdir + "/0.txt"):
        return

    subprocess.run(["rm", "-rf", sysroot_drvdir], check=True)

    os.makedirs(sysroot_drvdir + "/sysroot/")

    for bi_drv in build_inputs:
        bi_workdir = dirpaths.get_basedir() + "/" + bi_drv + "-workdir"
        bi_dest = bi_workdir + "/out/destdir"
        if not os.path.isfile(bi_workdir + "/0.txt"):
            raise Exception(f"dependency in {bi_dest} not built!")
        print(f"copying from {bi_dest}/ to {sysroot_drvdir}/sysroot/")
        util_functions.copy_root(
            src=bi_dest + "/", dest=sysroot_drvdir + "/sysroot/")

    ropaths = ["packed", "files", "patches", "build.sh"]
    rwpaths = ["src", "build", "out"]

    sysroot = sysroot_drvdir + "/sysroot/"
    for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev", "/pkgs"]:
        os.makedirs(sysroot + d, exist_ok=True)

    # uses_ccache = drv["enableCcache"]
    if uses_ccache:
        for compiler in [
            "gcc",
            "cc",
            "clang",
            "g++",
            "clang++",
            "x86_64-pc-linux-musl-c++",
            "x86_64-pc-linux-musl-g++",
            "x86_64-pc-linux-musl-gcc",
            "x86_64-linux-musl-c++",
            "x86_64-linux-musl-g++",
            "x86_64-linux-musl-gcc",
        ]:
            if os.path.exists(sysroot + "/usr/bin/" + compiler):
                cmd = ["ln", "-s", "/usr/bin/ccache", compiler]
                directory = sysroot + "/usr/lib/ccache"
                senv = {"PATH": os.getenv("PATH"), "HOME": "/"}
                subprocess.run(cmd, cwd=directory, env=senv, check=True)

    subprocess.run(["touch", sysroot_drvdir + "/0.txt"], check=True)
