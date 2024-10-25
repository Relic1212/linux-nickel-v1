let _gnumake = {
  baseName = "gnumake",

  singleSource = (import "gnumake-src.ncl"),
}
in
{
  lib,
  pkgs,

  gnumakeStage2 | lib.AutotoolsPackage
    =
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

  gnumakeStage3 | lib.AutotoolsPackage
    =
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
  gnumake | lib.AutotoolsPackage
    =
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
