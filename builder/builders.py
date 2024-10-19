
import json
import os
import subprocess 
import fetcher
def autotools_configure(srcdir:str,flags):
    rp = os.path.relpath(srcdir)
    if not os.path.isfile(f"{rp}/configure"):
        raise FileNotFoundError(f"{srcdir} does not contain configure")
    
    subprocess.run([f'{rp}/configure'],check=True)


def nickel_to_json(nickel_path:str):
    s=subprocess.run(["nickel", "export","--format=json",nickel_path],capture_output=True,check=True).stdout.decode()
    j=json.loads(s)
    return j 

def get_pkgs():
    pass

def prepare_build(drv:dict):
    buildInputs=drv["buildInputs"]
    sourceInputs=drv["sourceInputs"]


def test():
    j=nickel_to_json("./pkgs/musl/musl.ncl")
    # print(j)
    for elem in j['sourceInputs']:
        src=elem["src"]
        uri=src['uri']

        sha256sum=src['sha256sum']
        print(uri,sha256sum)
        fetcher.fetch(uri,sha256sum)
if __name__=="__main__":
    test()