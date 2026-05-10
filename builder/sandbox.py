"""_summary_

    Raises:
        Exception: _description_
"""
import os
import subprocess


def _run_unshared(target):

    prev = os.getpid()

    fd = os.eventfd(0, 0)

    if fd < 0:
        raise IOError(f"fd {fd}")
    p = os.fork()
    if p == 0:
        os.eventfd_read(fd)
        os.close(fd)
        with open(f"/proc/{prev}/setgroups", "wb") as f:
            f.write("deny\n".encode())

        with open(f"/proc/{prev}/gid_map", "wb") as f:
            f.write(f"0 {os.getgid()} 1\n".encode())

        with open(f"/proc/{prev}/uid_map", "wb") as f:
            f.write(f"0 {os.getuid()} 1\n".encode())
        exit(0)

    else:
        # os.unshare(os.CLONE_FILES|os.CLONE_FS|os.CLONE_NEWCGROUP|os.CLONE_NEWIPC|os.CLONE_NEWNET|os.CLONE_NEWNS|os.CLONE_NEWPID|os.CLONE_NEWTIME|os.CLONE_NEWUSER|os.CLONE_NEWUTS|os.CLONE_SIGHAND|os.CLONE_SYSVSEM|os.CLONE_THREAD|os.CLONE_VM)
        os.unshare(os.CLONE_NEWUSER | os.CLONE_NEWNS |
                   os.CLONE_NEWIPC | os.CLONE_NEWNET)
        os.eventfd_write(fd, 1)
        os.close(fd)
        os.waitpid(p, 0)

        target()


def _run_in_sandbox(target):
    def run_target_unshared():
        _run_unshared(target=target)

    fd = os.eventfd(12, 0)
    pid = os.fork()
    if pid == 0:
        os.eventfd_read(fd)
        os.close(fd)
        run_target_unshared()
        exit(0)
    else:
        os.eventfd_write(fd, 1)
        os.close(fd)
        os.waitpid(pid, 0)


def run_in_chroot(root: str, target):
    """Run a function in a chroot

    Args:
        root (str): path to rootfs to chroot into
        target (_type_): function to run
    """
    def cmd():
        subprocess.run(
            [
                "mount",
                "-t",
                "tmpfs",
                "-o",
                "nosuid,nodev,mode=1777",
                "none",
                f"{root}/tmp",
            ],
            check=True,
        )
        subprocess.run(
            ["mount", "-t", "tmpfs", "-o",
                "nodev,nosuid", "none", f"{root}/run"],
            check=True,
        )
        # subprocess.run(['mount','-t','proc','none',f'{root}/proc'],check=True)
        # subprocess.run(['mount','-t','sysfs','none',f'{root}/sys'],check=True)
        # subprocess.run(["mount", "--bind", "/dev/zero", f"{root}/dev/zero"], check=True)
        subprocess.run(["mount", "--bind", "/dev", f"{root}/dev"], check=True)

        # subprocess.run(['mount',"-v",'--bind',f'{root}',"/"],check=True)

        os.chroot(root)

        target()

    _run_in_sandbox(cmd)


def test():
    """test run_in_chroot
    """
    def target():
        # subprocess.run(["ls", "-l", "/"],check=True)
        subprocess.run(["wget", "jogg.se"], check=True)

    root = "/data/user/Projects/misc-linux-a2/experiments/nickel/sysroot"
    run_in_chroot(root, target)
    subprocess.run(["ls", "/"], check=True)
    print("finished")


if __name__ == "__main__":
    test()
