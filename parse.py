import os
import subprocess
import json 
import hashlib
import sys 
from builder import build_in_bubblewrap
def nickel_to_json(fp):
    c=subprocess.run(["nickel", "export", fp , "--format", "json"],check=True,capture_output=True)
    return json.loads(c.stdout.decode())


def a():
    for r,_,fs in os.walk("pkgs"):
        for f in fs:
            fp = f'{r}/{f}'
            c=subprocess.run(["nickel", "export", fp , "--format", "json"],check=True,capture_output=True)
            #print(type(c))
            s=c.stdout.decode()
            #print((s))

            # nix replace subdarivation with their hash, so we do that to
            d=json.loads(s)
            print('d',d)
            print("sha",hashlib.sha256(json.dumps(d).encode()).hexdigest())

def get_drvs():
    fp="nickellib/pkgs.ncl"
    c=nickel_to_json(fp)
    return c
def reverse_dict(d:dict[str,str])->dict[str,str]:
    d2={}

    for k in d:
        v=d[k]
        d2[v]=k 
    return d2

def test():
    pn=sys.argv[1]
    drvs=get_drvs()
    pn_hash = drvs['hashByName'][pn]
    print(pn_hash)
    hbn= drvs["hashByName"]
    nbh =reverse_dict(hbn)

    build_in_bubblewrap.build(pn_hash,drvs['drvByHash'])

if __name__=="__main__":
    test()