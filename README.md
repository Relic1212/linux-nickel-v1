
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

* Structure of the file:
** env (environment variables)
** build inputs
** sources (passed to the fetch function implemented in python)
** optionally, any of the phases unpackPhase, patchPhase, configurePhase, buildPhase and installPhase
** a phase is a dict with args to pass to aubprocess.run, shell bool and optional env (otherwise package env will be used)
** Alternatovely, it cpuld be a list of commands (strings) that are written to a build script by python and then executed, possyvly with a bubblewrap wrapper   
** host builddeps (tools needed to build package)
** deps (libs etc needed to build package)
** runtime deps (needed on target to run package)
** extraFiles (files to add to /tmp/work)