#!/usr/bin/env python

import os
import sys


if "-shared" in sys.argv:
    cmd = "ar"
    # args = ["ar", "cr"]
    args = ["ar", "rcs"]

    lib = ""
    argv2 = sys.argv[2:]
    objs = []
    for i, arg in enumerate(argv2):
        if arg == "-o":
            lib = argv2[i+1]
        elif arg.endswith(".o") or arg.endswith(".lo"):
            objs.append(arg)
    args += [lib]+objs

else:
    cmd = "clang"
    args = ["clang"] + sys.argv[1:]

print(f"executing {cmd} {args}", file=sys.stderr)
os.execvp(cmd, args)
