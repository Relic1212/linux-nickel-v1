import os
import shutil
import subprocess
import json

try:
    import hashes, bubblewrap

    # import builder.hashes as hashes
except:
    # import hashes
    from builder import hashes, bubblewrap


try:
    import dirpaths
except:
    from builder import dirpaths


def fetch_by_hash(h:str,drv_dict):
    drv_s=drv_dict[h]
    fetch_by_drv_string(drv_s=drv_s)

def fetch_by_drv_string(drv_s:str):
    drv=json.loads(drv_s)
    fetch_by_drv(drv=drv)

def fetch_by_drv(drv:dict):
    uri=drv['uri']
    sha256sum=drv['sha256sum']
    fetch(uri=uri,sha256sum=sha256sum)
def fetch(uri: str, sha256sum):
    """_summary_

    Args:
        uri (str): _description_
        sha256sum (_type_): _description_

    Raises:
        Exception: _description_
        Exception: _description_
        Exception: _description_
    """
    if uri.startswith("http") or uri.startswith("git://"):
        t = "online"
    elif os.path.exists(uri):
        t = "local"
    else:
        raise Exception(f"bad uri: \"{uri}\"")

    if t == "local":
        cmd = "cp"
    else:
        if uri.endswith(".git") or uri.startswith("git://"):
            cmd = "git"
        else:
            cmd = "wget"
    # cwd="."
    fetcherwd = dirpaths.get_basedir() + f"/{sha256sum}-src"
    if os.path.isfile(fetcherwd + "/0.txt"):
        return
    subprocess.run(["rm", "-rf", fetcherwd], check=True)
    packedwd = fetcherwd + "/packed"
    os.makedirs(packedwd)
    env = {"PATH": os.environ.get("PATH"), "HOME": "/"}
    carr = [cmd, uri]
    if t == "local":
        # -r?
        carr.append(".")
    bwrap_args = ["--bind", packedwd, "/tmp/workdir/packed"]
    # bubblewrap.run_in_bwrap_chroot(
    #     sysroot="/",
    #     extra_bwrap_args=bwrap_args + [ "--chdir", "/tmp/workdir/packed" ]  + carr,
    #     network=True,
    #     env=env,
    # )
    if cmd !="git":
        subprocess.run(carr, cwd=packedwd, env=env, check=True)
    else:
        subprocess.run(["git","clone",uri], cwd=packedwd, env=env, check=True)

    dirs = os.listdir(packedwd)
    if len(dirs) != 1:
        raise Exception(f"{uri}")
    fetched = packedwd + "/" + dirs[0]

    if cmd == "git":
        ds = os.listdir(packedwd)
        if len(ds)!=1:
            raise Exception(f"{packedwd} (fetched with git) does not contain exactly one directory")
        gitwd= ds[0]
        cmd_arr = ["git", "reset" ,"--hard", sha256sum]
        bubblewrap.run_in_bwrap_chroot(
            sysroot="/",
            sysroot_args=[],
            extra_bwrap_args=bwrap_args + [ "--chdir", f"/tmp/workdir/packed/{gitwd}" ] + cmd_arr,
            network=False,
            env=env
        )

        # subprocess.run(cmd_arr,env=env,cwd=fetched,check=True)
    else:
        h = hashes.compute_file_or_dir_sha256sum(fetched)

        if h != sha256sum:
            raise Exception(f"sha256sum missmatch for {uri}\nExpected: {sha256sum}\nGot: {h}")
        else:
            print(f"verified that {h} == {sha256sum}")

    subprocess.run(["touch", fetcherwd + "/0.txt"], check=True)
