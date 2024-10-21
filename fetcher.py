
import os
import subprocess
import builder.hashes as hashes
def fetch(uri:str,sha256sum):
    """_summary_

    Args:
        uri (str): _description_
        sha256sum (_type_): _description_

    Raises:
        Exception: _description_
        Exception: _description_
        Exception: _description_
    """    
    if uri.startswith("http"):
        t="online"
    elif os.path.exists(uri):
        t="local"
    else:
        raise Exception(f"bad uri: {uri}")
    
    if t=="local":
        cmd="cp"
    else:
        if uri.endswith(".git"):
            cmd="git"
        else:
            cmd="wget"
    cwd="."
    env={
        "PATH":os.environ.get("PATH"),
        "HOME":"/"
    }
    subprocess.run([cmd,uri],cwd=cwd,env=env,check=True)
    dirs = os.listdir(cwd)
    if len(dirs)!=1:
        raise Exception(f"{uri}")
    fetched =dirs[0]

    if cmd=="git":
        subprocess.run(["git", "reset" "--hard",sha256sum],env=env,cwd=fetched,check=True)
    else:
        h=hashes.compute_file_or_dir_sha256sum(fetched)
        if h!=sha256sum:
            raise Exception(f"sha256sum error for {uri}\nExpected: {sha256sum}\nGot: {h}")
        