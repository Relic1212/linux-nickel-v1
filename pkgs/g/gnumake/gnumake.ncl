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
        biDrvs =
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
  gnumakeStage4 | lib.AutotoolsPackage
    =
      _gnumake
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage2,
            pkgs.llvmStage2,
            pkgs.muslStage3,
            pkgs.gnumakeStage3,
            pkgs.ccacheBin,
          ]
      },

  # final
  gnumake | lib.AutotoolsPackage
    =
      _gnumake
      & {
        stage = -1,

        utilsProviders = [],
        baseBuildinputPackages = [],
        biDrvs =
          lib.biMap [
            pkgs.busyboxStage3,
            pkgs.llvmStage3,
            pkgs.musl,
            pkgs.gnumakeStage4,
            pkgs.ccacheBin,
          ]
      },
}
