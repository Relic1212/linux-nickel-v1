# from parse import get_drvs
import json
import os 
import subprocess
from parse import get_drvs
def main():
    drvs = get_drvs("")
    # with open("test/0815.json") as f:
    #     drvs= json.load(f)["data"]
    hbn = drvs["drvByHash"]
    pkghash2sysroothash = drvs["pkghash2sysroothash"]

    dirs = os.listdir("build")
    # builds = []
    # for d in dirs:
    #     p = os.path.join("build",d)
    #     if not os.path.exists( os.path.join( p,"out/destdir")):
    #         continue 
    #     elif (not d.endswith("workdir")):
    #         continue
    #     h = d.split("-")[0]
    #     builds.append(h)

    new_ones = [x[0] for x in list(hbn.items())] + [y for y in list(pkghash2sysroothash.values())]

    rm = []
    keep = [] 
    for b in dirs:
        h = b.split("-")[0]
        if len(h)!= 64:
            continue
        if h in new_ones:
            keep.append(b)
        else:
            rm.append(b)
    for r in rm:
        print("rm:", r)
        p = os.path.join("build",r)
        subprocess.run (["mv", p , "tmp"])
    for n in new_ones:
        if not (len(n)==64):
            print("new:",n)
    for k in keep:
        print("keep:", k)

    
if __name__=="__main__":
    main()
