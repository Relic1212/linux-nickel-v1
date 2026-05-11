import os
import multiprocessing


def unshare_run(fun, allow_net=False):
    child_r, child_w = os.pipe()
    child_error_r, child_error_w = os.pipe()
    parent_r, parent_w = os.pipe()

    # ret_r, ret_w = multiprocessing.Pipe()
    mask = os.CLONE_NEWUSER | os.CLONE_NEWNS
    if not allow_net:
        mask = mask | os.CLONE_NEWNET
    pid = os.fork()
    if pid == 0:
        try:
            os.close(child_r)
            os.close(child_error_r)
            try:
                os.unshare(mask)
                os.write(child_w, b's')  # d = done
            except:
                os.write(child_w, b'f')  # d = done

            os.read(parent_r, 1)

            error = False
            try:
                fun()
            except Exception as e:
                error = True
            if error:
                os.write(child_error_w, b'f')
            else:
                os.write(child_error_w, b's')

            # print(f"inside: {os.getuid()}:{os.getgid()}")
            # ret_w.send((ret_val, error))
            # ret_w.close()
            os.close(child_w)
            os.close(child_error_w)
        except Exception:
            os.close(child_w)
            os.close(child_error_w)
            os._exit(1)
        os._exit(0)

    os.close(parent_r)
    print("outside: waiting for unshare status")

    unshare_status = (os.read(child_r, 1)).decode()
    # print("outiside: read 1, pid =", pid)
    with open(f"/proc/{pid}/uid_map", "wb") as f:
        f.write((f" 0 {os.getuid()} 1").encode())

    with open(f"/proc/{pid}/setgroups", "wb") as f:
        f.write(b"deny")

    with open(f"/proc/{pid}/gid_map", "wb") as f:
        f.write((f" 0 {os.getgid()} 1").encode())
    os.write(parent_w, b"d")
    print("outside: waiting for fun() status")

    child_status_bytes = os.read(child_error_r, 1)
    child_status = child_status_bytes.decode()
    if not child_status in ['f', 's']:
        raise Exception(f"invalid child status: \"{child_status}\"")

    os.close(parent_w)
    # ret_w.close()
    # ret_val_p, error = ret_r.recv()

    os.waitpid(pid, 0)
    if child_status == 'f':
        raise Exception("fun failed")

    if unshare_status == 'f':
        raise Exception("unshare failed")
    return
