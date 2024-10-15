import os
import subprocess
import json 
import hashlib
for r,_,fs in os.walk("pkgs"):
    for f in fs:
        fp = f'{r}/{f}'
        c=subprocess.run(["nickel", "export", fp , "--format", "json"],check=True,capture_output=True)
        #print(type(c))
        s=c.stdout.decode()
        #print((s))
        d=json.loads(s)
        print('d',d)
        print("sha",hashlib.sha256(json.dumps(d).encode()).hexdigest())