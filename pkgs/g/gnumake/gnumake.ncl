let _gnumake = {
  baseName = "gnumake",

  singleSource = (import "gnumake-src.ncl"),
}
in
{
  lib,
  drvs,

  gnumakeStage2 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = 2,
      biDrvs =
         [
          drvs.busyboxStage1,
          drvs.llvmStage1,
          drvs.muslStage1,
          drvs.gnumakeStage1,
          drvs.ccacheBin,
        ]
    },

  gnumakeStage3 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = 3,
      buildInputs =
         [
          drvs.busyboxStage2,
          drvs.llvmStage2,
          drvs.muslStage2,
          drvs.gnumakeStage2,
          drvs.ccacheBin,
        ]
    },
  gnumakeStage4 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
         [
          drvs.busyboxStage2,
          drvs.llvmStage2,
          drvs.muslStage3,
          drvs.gnumakeStage3,
          drvs.ccacheBin,
        ]
    },

  # final
  gnumake | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
         [
          drvs.busyboxStage3,
          drvs.llvmStage3,
          drvs.musl,
          drvs.gnumakeStage4,
          drvs.ccacheBin,
        ]
    },
}
