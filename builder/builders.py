import json
import os
import subprocess

try:
    import fetcher
finally:
    from builder import fetcher

try:
    import dirpaths
finally:
    from builder import dirpaths


def autotools_configure(srcdir: str, flags):
    rp = os.path.relpath(srcdir)
    if not os.path.isfile(f"{rp}/configure"):
        raise FileNotFoundError(f"{srcdir} does not contain configure")

    subprocess.run([f"{rp}/configure"], check=True)


def nickel_to_json(nickel_path: str):
    s = subprocess.run(
        ["nickel", "export", "--format=json", nickel_path],
        capture_output=True,
        check=True,
    ).stdout.decode()
    j = json.loads(s)
    return j


def get_pkgs():
    pass


def _prepare_build(drv: dict, drvs_by_hash: dict):
    drvHash = drv["hash"]
    drv2 = drv["drv"]
    buildInputDrvs = drv2["buildInputDrvs"]
    sourceInputDrvs = drv2["sourceInputDrvs"]
    patchDrvs = drv2["patchDrvs"]
    extraFileDrvs = drv2["extraFileDrvs"]

    buildInputs = [drvs_by_hash[h] for h in buildInputDrvs]
    sourceInputs = [drvs_by_hash[h] for h in sourceInputDrvs]

    patches = [drvs_by_hash[h] for h in patchDrvs]
    extraFiles = [drvs_by_hash[h] for h in extraFileDrvs]

    for s in sourceInputs + patches + extraFiles:
        fetcher.fetch(uri=s["uri"], sha256sum=s["sha256sum"])

    workdir = f"{dirpaths.get_basedir()}/{drvHash}-workdir"
    for d in ["build", "src", "patches", "files", "out/destdir"]:
        os.makedirs( f"{workdir}/{d}", exist_ok=True)
    
    for s in sourceInputDrvs:
        sourceDir=f"{dirpaths.get_basedir()}/{s.hash}-src/unpacked"
        cont = os.listdir(sourceDir)
        if len(cont)!=0:
            raise Exception(f"ERROR: {sourceDir} does not contain exectly one source")
        source = f"{sourceDir}/{cont[0]}"
        dest =  workdir + "/src/" +  s['dest']
        os.makedirs(dest,exist_ok=True)
        subprocess.run(["cp","-r",source,dest])


def test():
    j = nickel_to_json("./pkgs/musl/musl.ncl")
    # print(j)
    for elem in j["sourceInputs"]:
        src = elem["src"]
        uri = src["uri"]

        sha256sum = src["sha256sum"]
        print(uri, sha256sum)
        fetcher.fetch(uri, sha256sum)


if __name__ == "__main__":
    test()
