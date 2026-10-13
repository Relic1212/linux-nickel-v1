#!/usr/bin/python

import sys
import os

argv = sys.argv[1:]

print(f"CARGO_WRAPPER: got argv '{" ".join(sys.argv)}'", file=sys.stderr)

if argv[0] == "build" and not any([x.startswith("--target=") for x in argv]):
        
    i = argv.index("--target-dir")
    argv[i] = "--artifact-dir"
    if "release" in argv:
        argv[i+1] = argv[i+1] + "/release"
    elif "debug" in argv:
        argv[i+1] = argv[i+1] + "/debug"
    else:
        argv[i+1] = argv[i+1] + "/default"

    # argv = ["-Z", "unstable-options"]+argv
    # target_dir = argv[i+1]
    # argv = [argv[0]] + ["--target", "x86_64-unknown-linux-musl", "-Z", "unstable-options", "--artifact-dir", target_dir]+argv[1:]
    argv = [argv[0]] + ["--target", "x86_64-unknown-linux-musl"] + \
        ["-Z", "unstable-options"]+argv[1:]

print(f"CARGO_WRAPPER: running 'cargo {" ".join(argv)}'", file=sys.stderr)


os.execvp("/usr/bin/cargo", ["cargo"]+argv)
