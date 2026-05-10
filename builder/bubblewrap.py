import os
import subprocess

try:
    from builder import util_functions
except ModuleNotFoundError:
    import util_functions


def run_in_bwrap_chroot(
    sysroot: str, sysroot_args, extra_bwrap_args=None, network=False, env=None, cwd=None, **kwargs
) -> int:
    """
    RUn a command in a bubblewrap chroot
    sysroot: root to chroot into
    """
    if extra_bwrap_args is None:
        extra_bwrap_args = []
    net_args = []
    # if network and (sysroot!="/"):
    #     net_args = ["--ro-bind", "/etc/resolv.conf", "/etc/resolv.conf"]
    #     if not os.path.isdir(sysroot + "/etc"):
    #         os.mkdir(sysroot + "/etc")
    #     if not os.path.exists(sysroot + "/etc/resolv.conf"):
    #         subprocess.run(["touch ", sysroot + "/etc/resolv.conf"], check=True)
    bwrap_wrap = (
        [
            "unshare",
            "--map-root-user",
            "bwrap",
            "--ro-bind",
            sysroot,
            "/",
        ] + sysroot_args + [

            "--tmpfs",
            "/run",
            "--dev",
            "/dev",
            "--tmpfs",
            "/tmp",
            "--proc",
            "/proc"
        ]
        + net_args
        + extra_bwrap_args
    )

    print("\n" + ''.join([s+" " for s in bwrap_wrap])
          [: -1-len("/tmp/workdir/build.sh")] + "sh\n")
    subprocess.run(bwrap_wrap, check=True, cwd=cwd, env=env, **kwargs)
    return 0


def get_bwrap_wrap(
    sysroot: str, sysroot_args, extra_bwrap_args=None, network=False,
) -> list[str]:
    """
    Get command to run a command in a bubblewrap chroot
    sysroot: root to chroot into
    """
    if extra_bwrap_args is None:
        extra_bwrap_args = []
    net_args = []
    if network and (sysroot != "/"):
        net_args = ["--ro-bind", "/etc/resolv.conf", "/etc/resolv.conf"]
        # if not os.path.isdir(sysroot + "/etc"):
        #     os.mkdir(sysroot + "/etc")
        # if not os.path.exists(sysroot + "/etc/resolv.conf"):
        #     subprocess.run(["touch ", sysroot + "/etc/resolv.conf"], check=True)
    bwrap_wrap = (
        [
            # "unshare",
            # "--map-root-user",
            "bwrap",
            "--ro-bind",
            sysroot,
            "/",
        ] + sysroot_args + [
            "--tmpfs",
            "/run",
            "--dev",
            "/dev",
            "--tmpfs",
            "/tmp",
            "--proc",
            "/proc"
        ]
        + net_args
        + extra_bwrap_args
    )

    # print( "\n" + ''.join ([s+" " for s in  bwrap_wrap])[: -1-len  ("/tmp/workdir/build.sh")] + "sh\n")
    return bwrap_wrap


def get_paths_from_sysroot(output_sysroot: str) -> dict[str, list[str]]:
    dirs = []

    files = []
    for root, dirs2, files2 in os.walk(output_sysroot):
        for d in dirs2:
            d2 = os.path.join(root, d)[len(output_sysroot):]
            dirs.append(d2)
        for file in files2:
            f1 = os.path.join(root, file)
            f2 = os.path.join(root, file)[len(output_sysroot):]
            arg = ["--ro-bind", f1, f2]
            files.append(f2)

    ret = {
        "dirs": dirs,
        "files": files
    }
    return ret
