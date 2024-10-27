import os
import subprocess
import json 
import hashlib
import sys 
from builder import build_in_bubblewrap

class GraphNode:
    def __init__(self,name,packages):
        self.name=name
        self.packages=packages

def nickel_to_json(fp):
    c=subprocess.run(["nickel", "export", fp , "--format", "json"],check=False,capture_output=True)

    if c.returncode!=0:
        print(c.stderr.decode())
        raise subprocess.CalledProcessError(c.returncode,c.args)
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

def get_graph(drvs=None):
    import graphviz
    if drvs is None:
        drvs=get_drvs()
    hbn = drvs['hashByName']
    dbh=drvs['drvByHash']
    g=graphviz.Digraph()

    for name in hbn:
        g.node(name,name)
        # g[name]={"name":name,"deps":[]}

    for name in hbn:
        hk=hbn[name]
        drv=json.loads(dbh[hk])
        name2=drv["name"]
        buildinput_hashes=drv['buildInputDrvs']
        buildinput_names=[ json.loads(dbh[h])["name"] for h in buildinput_hashes]

        for  bname in buildinput_names:
            g.edge(name,bname)

    return(g)

def reverse_dict(d:dict[str,str])->dict[str,str]:
    d2={}

    for k in d:
        v=d[k]
        d2[v]=k 
    return d2


def build_all(drvs):
    failed=[]
    s=[]
    for k in drvs['hashByName'].keys():
        pn_hash=drvs['hashByName'][k]
        try:
            build_in_bubblewrap.build(pn_hash,drvs['drvByHash'])
            s.append(k)
        except:
            failed.append(k)
    
    print("The following packages succeded")
    print(s)
    if len(failed)>0:
        print("The following packages failed to build:")
        print(failed)
    

def what_is_not_built(drvs):
    non_built=[]
    for k in drvs['hashByName'].keys():
        
        pn_hash=drvs['hashByName'][k]
        d=f"build/{pn_hash}-workdir"
        f=d +"/0.txt"
        if not os.path.isfile(f):
            non_built.append(k)

    for n in non_built:
        print(n) 
    


def test():
    pn=sys.argv[1]
    drvs=get_drvs()
    if pn=="all":
        build_all(drvs)
        return
    if pn=="diff":
        what_is_not_built(drvs)
        return
    pn_hash = drvs['hashByName'][pn]
    print(pn_hash)
    # hbn= drvs["hashByName"]
    # nbh =reverse_dict(hbn)

    build_in_bubblewrap.build(pn_hash,drvs['drvByHash'])

if __name__=="__main__":
    test()