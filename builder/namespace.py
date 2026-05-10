import os
import multiprocessing


def unshare_run(fun, allow_net=False):
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

        ret_val = fun()

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

    with open(f"/proc/{pid}/gid_map", "wb") as f:
        f.write((f" 0 {os.getgid()} 1").encode())
    os.write(parent_w, b"mapping done")

    ret_w.close()
    ret_val_p = ret_r.recv()
    os.waitpid(pid, 0)

    return ret_val_p
