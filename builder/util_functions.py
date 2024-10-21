import hashlib
import os
import subprocess

try:
    import hashes
except ModuleNotFoundError:
    from builder import hashes


def get_files_from_dir(directory: str, extension=None) -> list[dict]:
    """
    Get files and their hashes in directory dir. Returns a list of dicst
    with 'file' and 'sha256sum' as keys,
    or None if dir does not exist.
    """
    files = []
    if os.path.isdir(directory):
        dir_filenames = os.listdir(directory)
        filenames = []
        for filename in dir_filenames:
            if extension:
                if filename.endswith(extension):
                    filenames.append(filename)
            else:
                filenames.append(filename)

        for filename in filenames:
            filepath = directory + "/" + filename
            if os.path.isfile(filepath):
                try:
                    with open(filepath) as f:
                        s = f.read()
                    sha256sum = hashes.str_to_sha256sum(s)
                except:
                    with open(filepath, "rb") as f:
                        bytes_read = f.read()
                    sha256sum = hashlib.sha256(bytes_read).hexdigest()
            elif os.path.isdir(filepath):
                sha256sum = hashes.compute_directoy_sha256sum(filepath)
            else:
                print(f"ERROR: {filepath} is neither a file nor a directory!")
                exit(1)
            files.append({"file": filename, "sha256sum": sha256sum})
    return sorted(files, key=lambda x: x["file"])


def get_default_rsync() -> list[str]:
    """Get the default command for running
        Rsync
    Returns:
        list[str]: beginning of rsync command
    """
    rsync = ["rsync", "-az", "--no-o", "--no-g", "--no-perms"]
    return rsync


def copy_root(src: str, dest: str, rsync=None):
    """Copy contents from one directory fo another

    Args:
        src (str): directory to copy from
        dest (str): directory to copy to
        rsync (_type_, optional): rsync command to use. Defaults to None.

    Raises:
        Exception: _description_
        Exception: _description_
        Exception: _description_
    """
    if rsync is None:
        rsync = get_default_rsync()
    if not os.path.isdir(src):
        print(f"ERROR: {src} does not exist")

        raise Exception
    if not os.path.isdir(dest):
        print(f"ERROR: {dest} does not exist")
        raise Exception

    cmd = rsync + [src, dest]
    subprocess.run(cmd, check=True)


def write_script(script_filepath: str, script_content: str) -> None:
    """Write a script to a file with #!/bin/sh as shebang

    Args:
        script_filepath (str): path to the file where the scipt should be written.
                                Must be in an existing directory. If the file exists
                                it will be overwritten.
        script_content (str): Script to write, excluding shebang

    Raises:
        Exception: _description_
    """
    with open(script_filepath, "w") as f:
        f.write(f"#!/bin/sh -e\n{script_content}")
    subprocess.run(["chmod", "+x", script_filepath], check=True)


def list_to_string(l: list[str]) -> str:
    return "".join([s + " " for s in l])


def classify_uri(uri: str):

    if uri.endswith(".zip"):
        uri_type = "zip"
    elif uri.endswith(".git"):
        uri_type = "git"
    elif os.path.isdir(uri):
        uri_type = "dir"
    # elif os.path.isfile(uri):
    #     uri_type="local_file"
    else:
        found = False
        for ext in [".tar.gz", ".tar.xz", ".tar.bz", ".tar.gzip", ".tar.bz2", ".tgz"]:
            if uri.endswith(ext):
                uri_type = "tar"
                found = True
                break
        if not found:
            uri_type = "file"

    return uri_type
