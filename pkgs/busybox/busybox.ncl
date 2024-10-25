(import "busybox-base.ncl")
& {
  lib,
  pkgs,
  _busyboxBaseTarget,

  busyboxStage1 =
    _busyboxBaseTarget
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage0,
          pkgs.llvmStage1,
          pkgs.muslStage1,
          pkgs.linuxHeadersStage1,
          pkgs.ccacheBin,
          pkgs.gnumakeStage1
        ]
    },

  busyboxStage2 =
    _busyboxBaseTarget
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage2,
          pkgs.muslStage2,
          pkgs.linuxHeadersStage2,
          pkgs.ccacheBin,
          pkgs.gnumakeStage2
        ]
    },

  #final

  busybox =
    _busyboxBaseTarget
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvm,
          pkgs.musl,
          pkgs.linuxHeaders,
          pkgs.ccacheBin,
          pkgs.gnumake
        ]
    }
}
