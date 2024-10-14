# import ctypes
# import multiprocessing
# import multiprocessing.process
import os
import subprocess
# try:
#     import ctypes
#     mess_size=8
#     mess=ctypes.c_uint64(1)
# finally:
#     pass

def show_ns():
    print(os.readlink("/proc/self/ns/mnt"))
    print(os.readlink("/proc/self/ns/user"))


def run_unshared(target):
    print(os.readlink("/proc/self/ns/mnt"))
    with open(f"/proc/{os.getpid()}/uid_map", "r") as f:
        print("1", f.read())
    prev = os.getpid()

    fd = os.eventfd(0, 0)

    if fd < 0:
        raise Exception(f"fd {fd}")
    p = os.fork()
    if p == 0:
        # print("reading")
        # mess_size=8
        # mess_size=ctypes.sizeof(ctypes.c_uint64)
        #os.read(fd, mess_size )
        os.eventfd_read(fd)
        # print("read,closing")
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
        os.unshare(os.CLONE_NEWUSER | os.CLONE_NEWNS|os.CLONE_NEWIPC)
        # mess = ctypes.c_uint64(1)
        # mess=bytes(8)
        #os.write(fd,mess)
        os.eventfd_write(fd,1)
        os.close(fd)
        os.waitpid(p, 0)

        with open(f"/proc/{prev}/uid_map", "r") as f:
            print("2", f.read())

        subprocess.run("whoami")
        print(os.getuid())
        # target()
        # os.setgid(0)
        # subprocess.run(f"deny > /proc/{os.getpid()}/setgroups",shell=True,check=True)

        # subprocess.run(f"echo 0 1000 1 > /proc/{os.getpid()}/uid_map",shell=True,check=True)
        with open(f"/proc/{os.getpid()}/uid_map", "r") as f:
            print("22", f.read())

        os.getgid()
        # subprocess.run("ls /home".split(),check=True)

        # subprocess.run("mount -t tmpfs none /home".split(),check=True)
        # subprocess.run("touch /home/file".split(),check=True)

        # subprocess.run("ls /home".split(),check=True)
        # subprocess.run("umount /home".split(),check=True)
        # subprocess.run("ls /home".split(),check=True)
        target()


def run_in_sandbox(target):
    def run_target_unshared():
        run_unshared(target=target)

    #run_target_unshared()
    # p1 = multiprocessing.Process(target=run_target_unshared)
    # p1.start()
    # p1.join()
    fd = os.eventfd(12,0)
    pid=os.fork()
    if pid==0:
        # os.read(fd,mess_size)
        os.eventfd_read(fd)
        os.close(fd)
        run_target_unshared()
        exit(0)
    else:
        # os.write(fd,mess)
        os.eventfd_write(fd,1)
        os.close(fd)
        os.waitpid(pid,0)



def test1():
    show_ns()

    def cmd():
        subprocess.run(
            "mount -t tmpfs none /home;findmnt /home", check=True, shell=True
        )

    run_in_sandbox(cmd)
    run_in_sandbox(cmd)
    os.system("bwrap  --bind / / ls")

    show_ns()



def test():
    def target():
        subprocess.run(["ls","-l", "/"])
    root="/data/user/Projects/misc-linux-a2/experiments/nickel/sysroot"
    run_in_chroot(root,target)
    subprocess.run(['ls',"/"],check=True)
    show_ns()
    print("finished")


def run_in_chroot(root:str,target):
    def cmd():
        subprocess.run(['mount','-t','tmpfs','-o','nosuid,nodev,mode=1777','none',f'{root}/tmp'],check=True)
        subprocess.run(['mount','-t','tmpfs','-o','nodev,nosuid','none',f'{root}/run'],check=True)
        # subprocess.run(['mount','-t','proc','none',f'{root}/proc'],check=True)
        # subprocess.run(['mount','-t','sysfs','none',f'{root}/sys'],check=True)
        subprocess.run(['mount','--bind','/dev/zero',f'{root}/dev/zero'],check=True)
        subprocess.run(['ls',"/"],check=True)

        # subprocess.run(['mount',"-v",'--bind',f'{root}',"/"],check=True)

        os.chroot(root)
        subprocess.run(['ls',"/"],check=True)


        target()
    run_in_sandbox(cmd)





if __name__ == "__main__":
    test()
