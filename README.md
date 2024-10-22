
* Generate json package info with nickel (python executes nickel-2-json)
* Parse the json with python
* Execute parsed python code in a sandbox
* Sandbox alternatives:
    ** Call the bwrap binary
    ** Call the unshare binary
    ** Call os.unshare in the beginning and execute everything in a sandbox (how about networking?)
    ** Use multiprocessing module and a different process, in which os.unshare is called, once for every package

* Builds happen im /tmp/work, where the following directories are special:
** ./build
** ./src 
** ./packed
** ./patches
** ./files
** ./out

* Structure of the file:
** env (environment variables)
** build inputs
** sources (passed to the fetch function implemented in python)
** optionally, any of the phases unpackPhase, patchPhase, configurePhase, buildPhase and installPhase
** a phase is  a list of commands (strings) that are written to a build script by python and then executed with a bubblewrap wrapper   
** TODO: host builddeps (tools needed to build package)
** TODO: deps (libs etc needed to build package)
** TODO: runtime deps (needed on target to run package)
** Currently there is only buildInputs, reprecenting host builddeps and deps
** extraFiles (files to add to /tmp/files)
** patches (files to add to /tmp/patches)

* Stage 0 packages needed in chroot:
** Busybox
** Musl
** Llvm

In chroot, build make,bison,flex, cmake, linux-headers, musl, llvm, busybox
