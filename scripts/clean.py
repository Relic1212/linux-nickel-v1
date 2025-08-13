from parse import get_drvs
import json
import os 
import subprocess
def main():
    # drvs = get_drvs()
    with open("test/0810.json") as f:
        drvs= json.load(f)
    hbn = drvs["hashByName"]

    dirs = os.listdir("build")
    builds = []
    for d in dirs:
        p = os.path.join("build",d)
        if not os.path.exists( os.path.join( p,"out/destdir")):
            continue 
        elif (not d.endswith("workdir")):
            continue
        h = d.split("-")[0]
        builds.append(h)

    new_ones = [x[1] for x in list(hbn.items())]

    rm = []
    keep = [] 
    for b in builds:
        if b in new_ones:
            keep.append(b)
        else:
            rm.append(b)
    for r in rm:
        print("rm:", r)
        p = os.path.join("build", f"{r}-workdir")
        subprocess.run (["mv", p , "tmp"])
    # for n in new_ones:
    #     print("new:",n)
    for k in keep:
        print("keep:", p)

    
if __name__=="__main__":
    main()