let _gnumake = {
  baseName = "gnumake",

  singleSource = (import "gnumake-src.ncl"),
}
in
{
  lib,
  busyboxStage1,
  llvmStage1,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  busyboxStage2,

  llvmStage2,
  muslStage2,
  muslStage3,
  busyboxStage3,
  llvmStage3,
  musl,

  gnumakeStage2 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = 2,
      biDrvs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    },

  gnumakeStage3 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = 3,
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
        ]
    },
  gnumakeStage4 | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = -1,

      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],
      biDrvs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          muslStage3,
          gnumakeStage3,
          ccacheBin,
        ]
    },

  # final
  gnumake | lib.AutotoolsPackage =
    _gnumake
    & {
      stage = -1,

      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],
      biDrvs =
        lib.biMap [
          busyboxStage3,
          llvmStage3,
          musl,
          gnumakeStage4,
          ccacheBin,
        ]
    },
}
