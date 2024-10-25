
let _gnumake 
  = {
    baseName = "gnumake",

  
        singleSource=(import "gnumake-src.ncl"),

  }
  in
{
  lib,
  pkgs,
  busyboxStage1,
  llvmStage1,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  gnumakeStage2 |lib.AutotoolsPackage=
    _gnumake
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
          pkgs.muslStage1,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
        ]
    },

  busyboxStage2,
  llvmStage2,
  muslStage2,
  gnumakeStage2,
  ccacheBin,
  gnumakeStage3  |lib.AutotoolsPackage=
    _gnumake
    & {
      stage = 3,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.muslStage2,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
        ]
    },

  # final
  musl,
  gnumake  |lib.AutotoolsPackage=
    _gnumake
    & {
      stage = -1,
      buildInputs =
        lib.biMap [
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
          pkgs.musl,
          pkgs.gnumakeStage3,
          pkgs.ccacheBin,
        ]
    },
}
