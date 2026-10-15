import os
import subprocess

d = "/home/user/linux-nickel-v1/build/tmp/python-cython/out/destdir/usr/lib/python3.12/site-packages/"


def getsym(path):
    s = subprocess.run(["llvm-nm", "--defined-only",
                       "--extern-only", path], capture_output=True, check=True)
    return [x.strip().split() for x in s.stdout.decode().split("\n")]


mods = []
for root, _, files in os.walk(d):
    for file in files:
        path = os.path.join(root, file)
        if path.endswith(".so") or ".so." in path:
            modname = path[len(d):].replace(
                "/", ".").replace(".cpython-312-x86_64-linux-gnu.so", "")

            syms = list(filter(lambda x: x.startswith("PyInit"), [
                        x[-1] for x in filter(lambda x: len(x) > 0, getsym(path))]))
            print(modname, syms)
