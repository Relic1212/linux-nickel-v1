import os
import subprocess
import json 
import hashlib

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

def test():
    fp="nickellib/pkgs.ncl"
    c=nickel_to_json(fp)
    # print(c)
    print(type(c))
    print(c.keys())
    drvByHash=c["drvByHash"]
    print(type(drvByHash))
    d=drvByHash
    hbn=c['hashByName']
    print(hbn.keys())
    for name in hbn:
        h=hbn[name]
        drv=drvByHash[h]
        j=json.loads(drv)
        print(j['scriptContent'])
        


if __name__=="__main__":
    test()