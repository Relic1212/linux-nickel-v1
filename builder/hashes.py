import os
import hashlib
import subprocess


def compute_file_or_dir_sha256sum(filepath: str):

    if os.path.isfile(filepath):
        try:
            with open(filepath) as f:
                s = f.read()
                sha256sum = str_to_sha256sum(s)
        except (UnicodeDecodeError,Exception):
            with open(filepath, "rb") as f:
                b = f.read()
                sha256sum = hashlib.sha256(b).hexdigest()
    elif os.path.isdir(filepath):
        sha256sum = compute_directoy_sha256sum(filepath)
    else:
        print(f"ERROR: {filepath} is neither a file nor a directory!")
        raise Exception

    return sha256sum


def compute_directoy_sha256sum(directory: str) -> str:

    dir_sha256sum=hashlib.sha256(subprocess.run([ "tar","cf","-",directory ],capture_output=True,check=True).stdout).hexdigest()

    return dir_sha256sum


def str_to_sha256sum(s: str) -> str:
    """
    returns the sha256 hash sum of str s
    """
    return hashlib.sha256(s.encode()).hexdigest()
