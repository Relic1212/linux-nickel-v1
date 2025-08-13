#!/usr/bin/env python

import os 

bdir = os.path.join("build", "tmp")
for d in os.listdir(bdir):
    logp = os.path.join(bdir,d, "b.log")
    if not os.path.isfile(logp):
        continue 
    with open(logp) as f:
        loglines = f.readlines()
    deps =""
    for line in loglines:
        if "found: NO" in line:
            # dep = line.split(" ")[2]
            dep = line.split(":")[0].split(" ")[-2]
            deps += f"{d}: {dep}\n"
    if not (deps==""):
        print(f"{deps}\n")
