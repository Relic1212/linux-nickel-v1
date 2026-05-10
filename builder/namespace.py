import os
import subprocess
import ctypes
import multiprocessing

# libc = ctypes.CDLL(None)
# libc.unshare.argtypes = (ctypes.c_int,)


# def mount_tmp(s):
#     print(f"s={s}")
#     return subprocess.run(["mount", "-v", "-t", "tmpfsb", "none", "/lib"], check=True)


def unshare_run(fun, allow_net=False):
    print("unashare_run_staring")
    r, w = os.pipe()
    parent_r, parent_w = os.pipe()

    ret_r, ret_w = multiprocessing.Pipe()
    mask = os.CLONE_NEWUSER | os.CLONE_NEWNS
    if allow_net:
        mask = mask | os.CLONE_NEWNET
    pid = os.fork()
    if pid == 0:
        os.close(r)
        os.unshare(mask)
        os.write(w, b'unshare done')
        os.read(parent_r, 1)
        with open("/proc/self/uid_map") as f:
            print("map:", f.read())
        # subprocess.run(["mount", "-v", "-t", "tmpfs",                "none", "/lib"], check=True)
        ret_val = fun()

        # subprocess.run(["whoami"])
        # print(f"inside: {os.getuid()}:{os.getgid()}")
        ret_w.send(ret_val)
        ret_w.close()

        os._exit(0)

    os.close(parent_r)
    # print("outiside: waiting")

    os.read(r, 1)
    # print("outiside: read 1, pid =", pid)
    with open(f"/proc/{pid}/uid_map", "wb") as f:
        f.write((f" 0 {os.getuid()} 1").encode())

    with open(f"/proc/{pid}/setgroups", "wb") as f:
        f.write(b"deny")

    # with open(f"/proc/{pid}/setgroups", "r") as f:
    #     print(f"setg: {f.read()}")

    with open(f"/proc/{pid}/gid_map", "wb") as f:
        f.write((f" 0 {os.getgid()} 1").encode())
    os.write(parent_w, b"mapping done")

    ret_w.close()
    ret_val_p = ret_r.recv()
    os.waitpid(pid, 0)
    # print(f"outside: {os.getuid()}")
    # print("f done")
    # print( "ret=", ret_val_p)
    return ret_val_p


def main():

    # unshare_run(lambda: mount_tmp("hello"))
    print("end of main")


if __name__ == "__main__":
    main()
