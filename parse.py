#!/usr/bin/env python

import os
import subprocess
import json
import hashlib
import sys
from builder import build_in_bubblewrap


class GraphNode:
    def __init__(self, name, packages):
        self.name = name
        self.packages = packages


def nickel_to_json(fp, args=None):
    if args == None:
        args = []

    c = subprocess.run(
        ["nickel", "export", fp, "--format", "json"] + args, check=False, capture_output=True
    )

    if c.returncode != 0:
        print(c.stderr.decode())
        raise subprocess.CalledProcessError(c.returncode, c.args)
    return json.loads(c.stdout.decode())


def a():
    for r, _, fs in os.walk("pkgs"):
        for f in fs:
            fp = f"{r}/{f}"
            c = subprocess.run(
                ["nickel", "export", fp, "--format", "json"],
                check=True,
                capture_output=True,
            )
            # print(type(c))
            s = c.stdout.decode()
            # print((s))

            # nix replace subdarivation with their hash, so we do that to
            d = json.loads(s)
            print("d", d)
            print("sha", hashlib.sha256(json.dumps(d).encode()).hexdigest())

def pn_to_pn_key(pn:str):
    pn_key = ""
    upper = False
    for c in pn:

        if c == "-":
            upper = True
        else:
            if upper:
                pn_key += c.upper()
                upper = False
            else:
                pn_key += c 
    return pn_key
            
        

def get_drvs(pn):
    fp = "nickellib/pkgs2.ncl"
    c = nickel_to_json(fp, args=["--", f"pn=\"{pn}\""])
    data = c["data"]
    return data


def get_graph(drvs=None):
    import graphviz

    if drvs is None:
        drvs = get_drvs()
    hbn = drvs["hashByName"]
    dbh = drvs["drvByHash"]
    g = graphviz.Digraph()

    for name in hbn:
        g.node(name, name)
        # g[name]={"name":name,"deps":[]}

    for name in hbn:
        hk = hbn[name]
        drv = json.loads(dbh[hk])
        name2 = drv["name"]
        buildinput_hashes = drv["buildInputDrvs"]
        buildinput_names = [json.loads(dbh[h])["name"]
                            for h in buildinput_hashes]

        for bname in buildinput_names:
            g.edge(name, bname)

    return g


def reverse_dict(d: dict[str, str]) -> dict[str, str]:
    d2 = {}

    for k in d:
        v = d[k]
        d2[v] = k
    return d2


def build_all(drvs):
    failed = []
    s = []
    for k in drvs["hashByName"].keys():
        pn_hash = drvs["hashByName"][k]
        try:
            build_in_bubblewrap.build(pn_hash, drvs["drvByHash"])
            s.append(k)
        finally:
            failed.append(k)

    print("The following packages succeded")
    print(s)
    if len(failed) > 0:
        print("The following packages failed to build:")
        print(failed)


def what_is_not_built(drvs: dict):
    """Print all derivations in the tree that do not have a successful buils

    Args:
        drvs (_type_): _description_
    """
    non_built = []
    for k in drvs["hashByName"].keys():

        pn_hash = drvs["hashByName"][k]
        d = f"build/{pn_hash}-workdir"
        f = d + "/0.txt"
        if not os.path.isfile(f):
            non_built.append(k)

    for n in non_built:
        print(n)


def diff2(drvs):
    non_built = []
    subprocess.run(["unlink", "build/hypothetical"], check=False)
    tmp = subprocess.run(["mktemp", "-d"], check=True,
                         capture_output=True).stdout.decode().strip()
    subprocess.run(["ln", "-s", tmp, "build/hypothetical"], check=True)

    diffs = 0
    same = 0
    notbuilt = 0
    diffing = []
    for k in drvs["hashByName"].keys():
        old_path = f"build/tmp/{k}"
        old = old_path + "/drv.json"
        old_status = old + "/0.txt"
        # print(old)

        if os.path.exists(old):
            with open(old, encoding="utf-8") as f:
                old_drv = json.load(f)

            old_script = old_drv["scriptContent"]

            new_h = drvs["hashByName"][k]

            new_drv = json.loads(drvs["drvByHash"][new_h])

            # print(new_drv)
            # print(type(new_drv))
            new_script = new_drv["scriptContent"]
            if not old_script == new_script:
                print(f"{k} differs")
                diffs += 1
                diffing.append(k)
                kd = (tmp + "/" + k)
                os.makedirs(kd)
                with open(kd + "/drv.json", "w") as f:
                    json.dump(new_drv, f)

                with open(kd + "/build.sh", "w") as f:
                    f.write(new_script)
                bdiff = subprocess.run(["diff", old_path + "/build.sh",  kd +
                                       "/build.sh"], capture_output=True, check=False).stdout.decode()
                print(bdiff)
                with open(kd + "build.diff", "w") as f:
                    f.write(bdiff)
            else:
                same += 1
        else:
            notbuilt += 1
    print(notbuilt, same, diffs)

    for k in diffing:
        print("diffs:", k)
    if (diffs) == 0:
        print("zero packages which have a successfull build in build/tmp would be built")


def test():
    pn = sys.argv[1]
    pn_key = pn_to_pn_key(pn)
    drvs = get_drvs(pn_key)
    # with open("test/0813.json") as f : drvs = json.load(f)
    if pn == "all":
        build_all(drvs)
        return
    if pn == "diff":
        what_is_not_built(drvs)
        return
    if pn == "diff2":
        diff2(drvs)
        return

    pn_hash = drvs["hashByName"][pn]
    print(pn_hash)
    hbn = drvs["hashByName"]
    nbh = reverse_dict(hbn)

    pkghash2sysroothash = drvs["pkghash2sysroothash"]

    build_in_bubblewrap.build(
        pn_hash, drvs["drvByHash"], pkg_names=nbh, pkghash2sysroothash=pkghash2sysroothash)


if __name__ == "__main__":
    test()
