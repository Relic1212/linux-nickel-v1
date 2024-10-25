# let lib = import "../../nickellib/lib.ncl"
# in
let flexBase = import "flex-base.ncl" in

{
  lib,
  pkgs,

  flexStage1 | lib.AutotoolsPackage
    =
      flexBase
      & {
        stage = 1,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage0,
            pkgs.muslStage1,
            pkgs.gnumakeStage1,
            pkgs.ccacheBin,
            pkgs.m4Stage1,
            pkgs.busyboxStage0,
          ]
      },

  #2

  flexStage2 | lib.AutotoolsPackage
    =
      flexBase
      & {
        stage = 2,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage1,
            pkgs.muslStage2,
            pkgs.gnumakeStage2,
            pkgs.ccacheBin,
            pkgs.m4Stage2,
            pkgs.busyboxStage1,
          ]
      },
  #final

  flex | lib.AutotoolsPackage
    =
      flexBase
      & {
        stage = -1,
        buildInputs =
          lib.biMap [
            pkgs.llvmStage2,
            pkgs.musl,
            pkgs.gnumake,
            pkgs.ccacheBin,
            pkgs.m4,
            pkgs.busyboxStage2,
          ]
      }
}
