{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSEnv {
  name = "simple-env";
  targetPkgs = pkgs: (with pkgs; [
    nickel    
    gnumake
    
    gcc-unwrapped
    binutils-unwrapped
    bubblewrap
    util-linux.bin
        stdenv.cc.cc.lib

    
  ]) ;
profile = ''
    export LIBRARY_PATH=/usr/lib
    export C_INCLUDE_PATH=/usr/include
    export CPLUS_INCLUDE_PATH=/usr/include
    export CMAKE_LIBRARY_PATH=/usr/lib
    export CMAKE_INCLUDE_PATH=/usr/include bash
  '';
  runScript = "bash";
}).env
