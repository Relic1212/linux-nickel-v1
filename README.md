
* Generate json package info with nickel (python executes nickel-2-json)
* Parse the json with python
* Execute parsed python code in a sandbox
* Sandbox alternatives:
    ** Call the bwrap binary
    ** Call the unshare binary
    ** Call os.unshare in the beginning and execute everything in a sandbox (how about networking?)
    ** Use multiprocessing module and a different process, in which os.unshare is called, once for every package