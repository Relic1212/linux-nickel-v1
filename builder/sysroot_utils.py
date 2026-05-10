import os
import subprocess
import hashlib
import timeit
import datetime
try:
    from builder import bubblewrap, hashes, util_functions, dirpaths, fetcher
except ModuleNotFoundError:
    import bubblewrap
    import hashes
    import util_functions
    import dirpaths
    import fetcher


# def prepare_sysroot(drv, workdir) -> list:
#     build_in_chroot = drv["buildInChroot"]
#     symlink_build_inputs = drv['symlinkBuldInputs']
#     if (not symlink_build_inputs):
#         return prepare_sysroot_copy(drv, workdir)
#     elif build_in_chroot:
#         print("FAIL for", drv)
#         raise Exception("symlink is incompatible with chroot")
#     else:
#         return prepare_sysroot_symlink(drv, workdir)


def prepare_sysroot_symlink(drv, workdir) -> list:
    bwrap_bi_drv_args = []
    bwrap_bi_drv_args = ["--tmpfs", "/pkgs"]

    for bi_drv in drv["buildInputDrvs"]:
        if type(bi_drv) is str:
            bi_drv_drv_hash = bi_drv
            bi_drv_dest_subdir = ""
        else:
            bi_drv_drv_hash = bi_drv["drvHash"]

            bi_drv_dest_subdir = bi_drv["dest"]

        bi_dest = dirpaths.get_basedir() + "/" + bi_drv_drv_hash + "-workdir/out/destdir"

        bi_dest_bwrap_args = bubblewrap.get_paths_from_sysroot(bi_dest)
        sysroot_dirs = bi_dest_bwrap_args['dirs']
        sysroot_files = bi_dest_bwrap_args['files']
        # all the dirs so the symlinks will work
        for bi_drv_dir in sysroot_dirs:
            dst = workdir + "/sysroot/" + bi_drv_dest_subdir + bi_drv_dir

            if os.path.isdir(dst):
                continue
            # maybe it is better to reverse order anf just skip if it exists
            if os.path.exists(dst) or os.path.islink(dst):
                os.remove(dst)
            os.makedirs(dst)

        # create intentianlly broken symlink
        for sd in sysroot_files:
            link_source = "/pkgs/"+bi_drv + sd
            link_target = workdir + "/sysroot" + bi_drv_dest_subdir + sd
            if os.path.exists(link_target) or os.path.islink(link_target):
                print(f"removing {link_target} to link")
                subprocess.run(["rm", "-rf", link_target], check=True)

            # print(f"linking {link_source} to {link_target}")
            subprocess.run(["ln", "-s", link_source, link_target], check=True)
        bwrap_bi_drv_args += ["--ro-bind", bi_dest, "/pkgs/" + bi_drv]

    return bwrap_bi_drv_args


# def prepare_sysroot_copy(drv, workdir) -> list:
#     bwrap_bi_drv_args = []

#     for bi_drv in drv["buildInputDrvs"]:
#         bi_dest = dirpaths.get_basedir() + "/" + bi_drv + "-workdir/out/destdir"

#         print(f"copying from {bi_dest}/ to {workdir}/sysroot/")
#         util_functions.copy_root(
#             src=bi_dest + "/", dest=workdir + "/sysroot/")
#     return bwrap_bi_drv_args


def build_sysroot(drv_hash, build_inputs, uses_ccache):
    # build_sysroot_copy(drv_hash, build_inputs, uses_ccache)
    build_sysroot_hardlink(drv_hash, build_inputs, uses_ccache)


# def build_sysroot_copy(drv_hash, build_inputs, uses_ccache):
#     sysroot_drvdir = dirpaths.get_basedir() + f"/{drv_hash}-sysroot"
#     if os.path.isfile(sysroot_drvdir + "/0.txt"):
#         return

#     subprocess.run(["rm", "-rf", sysroot_drvdir], check=True)

#     os.makedirs(sysroot_drvdir + "/sysroot/")

#     for bi_drv in build_inputs:
#         bi_workdir = dirpaths.get_basedir() + "/" + bi_drv + "-workdir"
#         bi_dest = bi_workdir + "/out/destdir"
#         if not os.path.isfile(bi_workdir + "/0.txt"):
#             raise Exception(f"dependency in {bi_dest} not built!")
#         print(f"copying from {bi_dest}/ to {sysroot_drvdir}/sysroot/")
#         util_functions.copy_root(
#             src=bi_dest + "/", dest=sysroot_drvdir + "/sysroot/")

#     ropaths = ["packed", "files", "patches", "build.sh"]
#     rwpaths = ["src", "build", "out"]

#     sysroot = sysroot_drvdir + "/sysroot/"
#     for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev", "/pkgs"]:
#         os.makedirs(sysroot + d, exist_ok=True)

#     # uses_ccache = drv["enableCcache"]
#     if uses_ccache:
#         for compiler in [
#             "gcc",
#             "cc",
#             "clang",
#             "g++",
#             "clang++",
#             "x86_64-pc-linux-musl-c++",
#             "x86_64-pc-linux-musl-g++",
#             "x86_64-pc-linux-musl-gcc",
#             "x86_64-linux-musl-c++",
#             "x86_64-linux-musl-g++",
#             "x86_64-linux-musl-gcc",
#         ]:
#             if os.path.exists(sysroot + "/usr/bin/" + compiler):
#                 cmd = ["ln", "-s", "/usr/bin/ccache", compiler]
#                 directory = sysroot + "/usr/lib/ccache"
#                 senv = {"PATH": os.getenv("PATH"), "HOME": "/"}
#                 subprocess.run(cmd, cwd=directory, env=senv, check=True)

#     subprocess.run(["touch", sysroot_drvdir + "/0.txt"], check=True)

def buildintput_hardlink(bi_dest, sysroot,  bi_drv_subdir_dest):
    drv_paths = bubblewrap.get_paths_from_sysroot(bi_dest)
    sysroot_dirs = drv_paths['dirs']
    sysroot_files = drv_paths['files']
    # all the dirs so the symlinks will work
    for bi_drv_dir in sysroot_dirs:
        dst = sysroot + bi_drv_subdir_dest + bi_drv_dir

        dir_source = bi_dest + bi_drv_dir

        if not os.path.islink(dir_source):  # it's a real dir
            if os.path.isdir(dst):
                continue
            # maybe it is better to reverse order anf just skip if it exists
            if os.path.exists(dst) or os.path.islink(dst):
                os.remove(dst)
            os.makedirs(dst)
        else:  # it's a symlink
            # TODO: is there a risk that the parent directory does not exist?
            subprocess.run(["cp",
                            #  "--no-dereference", gnu alias for -P
                            "-P", dir_source, dst], check=True)

    for sd in sysroot_files:
        link_source = bi_dest + sd
        link_target = sysroot + bi_drv_subdir_dest + sd
        if os.path.exists(link_target) or os.path.islink(link_target):
            # print(f"removing {link_target} to link")
            subprocess.run(["rm", "-rf", link_target], check=True)

        # print(f"linking {link_source} to {link_target}")

        # different implementations. Don't know what to do
        if not (os.path.islink(link_source)):
            try:
                subprocess.run(
                    ["ln", "-P", link_source, link_target], check=True)
            except subprocess.CalledProcessError:
                print("Warning: your ln does not support -P")
                subprocess.run(
                    ["ln", "-n", link_source, link_target], check=True)
            except subprocess.CalledProcessError:
                print("Warning: your ln supports neither -P nor -n")
                subprocess.run(["ln", link_source, link_target], check=True)
        else:
            # no point in creating hard links to symlinks
            subprocess.run(["cp", "-a", link_source, link_target], check=True)


def build_basepath_directory(basedir: str, uses_ccache: bool, known_compilers: list[str], destdirs: list[str]):
    """
    create basepaths (/dev, /tmp, etc) in basedir
    """
    ropaths = ["packed", "files", "patches", "build.sh"] + destdirs
    rwpaths = ["src", "build", "out"]

    for d in ropaths + rwpaths + ["/tmp", "/run", "/proc", "/sys", "/dev", "/pkgs"]:
        os.makedirs(basedir + d, exist_ok=True)

    # uses_ccache = drv["enableCcache"]
    if uses_ccache:

        for compiler in known_compilers:
            cmd = ["ln", "-s", "/usr/bin/ccache", compiler]
            directory = basedir + "/usr/lib/ccache"
            os.makedirs(directory, exist_ok=True)
            senv = {"PATH": os.getenv("PATH"), "HOME": "/"}
            subprocess.run(cmd, cwd=directory, env=senv, check=True)


def prepare_symlink_directory(symlink_directory: str, build_inputs: list, uses_ccache: bool) -> list[str]:
    """
    Prepare symlinks in symlink directory for build_inputs. Also create a directory for basepaths such as /dev
    returns bwrap args needed to chroot to a directory with the packages
    """
    pkg_symlink_dirs = []
    # s for sysroot (just any non-number)
    basepath = os.path.join(symlink_directory, "s")

    dests = {"": []}
    compilers = {

        "gcc": False,
        "cc": False,
        "clang": False,
        "g++": False,
        "clang++": False,
        # "x86_64-pc-linux-musl-c++":,
        # "x86_64-pc-linux-musl-g++",
        # "x86_64-pc-linux-musl-gcc",
        # "x86_64-linux-musl-c++",
        # "x86_64-linux-musl-g++",
        # "x86_64-linux-musl-gcc",

    }
    for i, bi_drv in enumerate(build_inputs):
        if type(bi_drv) is str:
            bi_drv_drv_hash = bi_drv
            bi_drv_subdir_dest = ""
        else:
            bi_drv_drv_hash = bi_drv["drvHash"]
            bi_drv_subdir_dest = bi_drv["dest"]

        bi_workdir = dirpaths.get_basedir() + "/" + bi_drv_drv_hash + "-workdir"
        bi_dest_rel = bi_workdir + "/out/destdir"
        bi_dest = os.path.realpath(bi_dest_rel, strict=True)

        symlink_subdir = str(i)
        symlink_package_dir = os.path.join(symlink_directory, symlink_subdir)
        if bi_drv_subdir_dest in dests:
            dests[bi_drv_subdir_dest].append(symlink_subdir)
        else:
            dests[bi_drv_subdir_dest] = [symlink_subdir]
        for compiler in compilers:
            if not compilers[compiler]:  # not yet found:
                if os.path.exists(os.path.join(bi_dest, "/usr/bin/", compiler)):
                    compilers[compiler] = True

        os.symlink(bi_dest, symlink_package_dir)
    dests[""].append("s")  # basepaths should be last

    args = []

    for dest in dests:  # "" key was added first
        linkdirs = dests[dest]
        if len(linkdirs) > 1:
            overlay_opts = "lowerdir=" + ":".join(linkdirs)
            mount_cmd = f"mount -t overlay overlay -o {overlay_opts} ${{TARGET_SYSROOT}}/{dest}"
            # there is something weird about the order
            # for linkdir in linkdirs:
            #     args+=["--overlay-src", linkdir]
            # args+=["--ro-overlay", os.path.join("/",dest) ]
        else:
            mount_cmd = f"mount --bind {linkdirs[0]} ${{TARGET_SYSROOT}}/{dest}"

    known_compilers = []
    destdirs = list(dests.keys())
    for c in compilers:
        if compilers[c]:
            known_compilers.append(c)
    build_basepath_directory(basepath, uses_ccache, known_compilers, destdirs)
    return args


def build_sysroot_hardlink(drv_hash, build_inputs, uses_ccache):
    t1 = timeit.default_timer()

    sysroot_drvdir = dirpaths.get_basedir() + f"/{drv_hash}-sysroot"
    sysroot = sysroot_drvdir + "/sysroot/"

    if os.path.isfile(sysroot_drvdir + "/0.txt"):
        return

    subprocess.run(["rm", "-rf", sysroot_drvdir], check=True)

    os.makedirs(sysroot_drvdir + "/sysroot/")

    for bi_drv in build_inputs:
        if type(bi_drv) is str:
            bi_drv_drv_hash = bi_drv
            bi_drv_subdir_dest = ""
        else:
            bi_drv_drv_hash = bi_drv["drvHash"]
            bi_drv_subdir_dest = bi_drv["dest"]

        bi_workdir = dirpaths.get_basedir() + "/" + bi_drv_drv_hash + "-workdir"
        bi_dest = bi_workdir + "/out/destdir"
        if not os.path.isfile(bi_workdir + "/0.txt"):
            raise Exception(f"dependency in {bi_dest} not built!")
        buildintput_hardlink(bi_dest, sysroot, bi_drv_subdir_dest)

    ropaths = ["packed", "files", "patches", "build.sh"]
    rwpaths = ["src", "build", "out"]

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
    t2 = timeit.default_timer()
    preptime = datetime.timedelta(seconds=t2-t1)
    print(f"praparing sysroot took {preptime}")
    subprocess.run(["touch", sysroot_drvdir + "/0.txt"], check=True)


def gen_recursice_overlay(script, dirs, sysroot):
    if len(dirs) == 1:
        d = dirs[0]
        script += f"mkdir -p /tmp/empty_last\n"
        script += f"mount -v -t overlay overlay -o ro,lowerdir={d} {sysroot}\n"
        return gen_recursice_overlay(script, [])

    elif len(dirs) == 2:
        d1 = dirs[0]
        d2 = dirs[1]
        script += f"mount -v -t overlay overlay -o ro,lowerdir={d1}:{d2} {sysroot}\n"
        return script
    count = len(dirs)
    if (count % 2) == 0:
        n = count // 2
        one_left = False
    else:
        n = (count - 1)//2
        one_left = True

    new_dirs = []
    for i in range(0, n*2, 2):
        d1 = dirs[i]
        d2 = dirs[i+1]
        new_dir = f"/tmp/{hashlib.sha256((d1 + d1).encode()).hexdigest()}"

        script += f"mkdir -p {new_dir}\n"
        script += f"mount -v -t overlay overlay -o ro,lowerdir={d1}:{d2} {new_dir}\n"
        new_dirs.append(new_dir)
    if one_left:
        new_dirs.append(dirs[-1])
    return gen_recursice_overlay(script, new_dirs, sysroot)


def build_overlay_sysroot(workdir, build_inputs, uses_ccache, build_in_sandbox):
    sysroot = f"{workdir}/sysroot"
    if (not build_in_sandbox) and (uses_ccache):
        raise Exception("ccache in non-chroot is not supported")

    max_len = 800  # TODO

    # build() should delete
    # subprocess.run(["rm", "-rf", sysroot_drvdir], check=True)

    script = "#!/bin/sh -e\n"
    script += "mount -t tmpfs none /tmp\n"
    script += f"mount -t tmpfs none {sysroot}\n"

    script += "mkdir /tmp/build\n"
    script += "mount -v --bind ./build /tmp/build\n"

    # lowerdirs = []
    # mount_commands = []
    args = []

    known_compilers = [
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
    ]
    compilers = []
    # symlink_args = []
    lowerdirs_s = ""
    lowerdirs = []
    for index, bi_drv in enumerate(build_inputs):
        bi_workdir = dirpaths.get_basedir() + "/" + bi_drv + "-workdir"
        bi_dest = bi_workdir + "/out/destdir"
        if not os.path.isfile(bi_workdir + "/0.txt"):
            raise Exception(f"dependency in {bi_dest} not built!")

        lowerdir = f"/tmp{bi_dest[1:]}"
        lowerdirs.append(lowerdir)
        # lowerdirs_s += f":{lowerdir}"

        # if (len(lowerdirs_s) + len(lowerdir) + 2 > max_len) or \
        #     ((len(lowerdirs_s) + 3 * len(lowerdir) + 2 > max_len) and (index > len(build_inputs) - 3)) \
        #         or (index == len(build_inputs)-1):
        #     lowerdirs_s = lowerdirs_s[1:]
        #     if not (":" in lowerdirs_s):
        #         script += "mkdir /tmp/rest\n"

        #         lowerdirs_s += ":/tmp/rest"
        #     mount_command = f"mount -v -t overlay overlay -o lowerdir={lowerdirs_s} $(realpath {sysroot})"
        #     script += f"echo -- \"{mount_command}\"\n"
        #     script += f"{mount_command}\n"
        #     lowerdirs_s = ""

        # print(f"overlay  from {bi_dest}/ to sysroot/")

        # arg = ["--overlay-src", bi_dest ]
        # arg =  [ "--overlay-src",
        #          bi_dest,
        #            "--overlay" ,
        #            "/tmp/w" ,
        #            "/tmp/empty",
        #              sysroot,
        #         ]
        # args += arg
        # script += "mount -t overlay overlay -o"
        # print("adding arg", arg)

        if uses_ccache:
            for compiler in known_compilers:
                if os.path.exists(bi_dest + "/usr/bin/" + compiler):
                    compilers.append(compiler)
                    # symlink_arg = ["--symlink", "/usr/bin/ccache",
                    #                f"/usr/lib/ccache/{compiler}"]
                    # symlink_args += symlink_arg

    script += gen_recursice_overlay("", lowerdirs, sysroot)

    if lowerdirs_s != "":
        # raise Exception("lowerdirs reamaining!")
        mount_command = f"mount -v -t overlay overlay -o lowerdir={lowerdirs_s[1:]}:/tmp/rest $(realpath {sysroot})"

        script += "mkdir -v /tmp/rest\n"
        script += f"{mount_command}\n"

    # this directory exists thanks do ccache but it is mounted ro
    if uses_ccache and False:
        script += f"mount -v -t tmpfs none '$(realpath {sysroot})'/usr/lib/ccache\n"
        for compiler in compilers:
            script += f"(cd {sysroot}/usr/lib/ccache ln -s /usr/bin/ccache {compiler})\n"

    # args += ["--tmp-overlay", "/"]
    # args += symlink_args

    if build_in_sandbox:
        script += f"mkdir -v -p /tmp/sysroot_procsysdev/run\n"
        script += f"mkdir -v -p /tmp/sysroot_procsysdev/dev\n"
        script += f"mkdir -v -p /tmp/sysroot_procsysdev/proc\n"
        script += f"mkdir -v -p /tmp/sysroot_procsysdev/tmp\n"
        script += f"touch /tmp/sysroot_procsysdev/build.sh\n"

        script += "mkdir  -v -p /tmp/rest2\n"
        script += f"mount -v -t overlay overlay -o lowerdir=/tmp/sysroot_procsysdev:/tmp/rest2 {sysroot}\n"

        script += f"mount -v -t tmpfs none {sysroot}/run\n"

        script += f"mount -v -t tmpfs none {sysroot}/dev\n"
        script += f"mount -v -t tmpfs none {sysroot}/tmp\n"

        # https://github.com/containers/bubblewrap/blob/d6180f25b164c708b8b0a0d86d6a9642f30cd9a9/bubblewrap.c#L1378

        for device in ["null", "zero", "full", "random", "urandom", "tty"]:
            script += f"touch {sysroot}/dev/{device}\n"
            script += f"mount -v --bind /dev/{device} {sysroot}/dev/{device}\n"

        # script += f"mount --bind /proc {sysroot}/proc\n"

        script += f"mkdir -v -p {sysroot}/tmp/workdir/packed\n"
        script += f"mount -v --bind -o ro {workdir}/packed {sysroot}/tmp/workdir/packed\n"

        script += f"mkdir -v -p {sysroot}/tmp/workdir/files\n"
        script += f"mount -v --bind -o ro {workdir}/files {sysroot}/tmp/workdir/files\n"

        script += f"mkdir -v -p {sysroot}/tmp/workdir/patches\n"
        script += f"mount -v --bind -o ro {workdir}/patches {sysroot}/tmp/workdir/patches\n"

        script += f"touch {sysroot}/tmp/workdir/build.sh\n"
        script += f"mount -v --bind -o ro {workdir}/build.sh {sysroot}/tmp/workdir/build.sh\n"

        script += f"mkdir -p {sysroot}/tmp/workdir/src\n"
        script += f"mount -v --bind {workdir}/src {sysroot}/tmp/workdir/src\n"

        script += f"mkdir -p {sysroot}/tmp/workdir/build\n"
        script += f"mount -v --bind {workdir}/build {sysroot}/tmp/workdir/build\n"
        # script += f"mount -v --bind {sysroot} /\n"

    else:

        script += f"mkdir -p /tmp/workdir/packed\n"
        script += f"mount -v --bind -o ro {workdir}/packed /tmp/workdir/packed\n"

        script += f"mkdir -p /tmp/workdir/files\n"
        script += f"mount -v --bind -o ro {workdir}/files /tmp/workdir/files\n"

        script += f"mkdir -p /tmp/workdir/patches\n"
        script += f"mount -v --bind -o ro {workdir}/patches /tmp/workdir/patches\n"

        script += f"touch /tmp/workdir/build.sh\n"
        script += f"mount -v --bind -o ro {workdir}/build.sh /tmp/workdir/build.sh\n"

        script += f"mkdir -p /tmp/workdir/src\n"
        script += "mount -v --bind {workdir}/src /tmp/workdir/src\n"

        script += f"mkdir -p /tmp/workdir/build\n"
        script += f"mount -v --bind {workdir}/build /tmp/workdir/build\n"

        script += f"mount -v --bind -o ro {sysroot} {sysroot}\n"

    script += f"chroot {sysroot} $@\n"

    return script


def unshare_wite_wrapper(workdir, script):
    fp = f"{workdir}/wrap-build.sh"
    with open(fp, "w", encoding="utf-8") as f:
        f.writa(script)
