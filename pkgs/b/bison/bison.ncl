{
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  busyboxStage0,
  llvmStage0,

  lib,
  # base
  _bisonBase | lib.AutotoolsPackage = {
    # baseName | default = "bison",
    sourceInputs = [
      {
        src = { uri = "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz", sha256sum = "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2" }
      }
    ],
  },
  # 1

  bisonStage1 | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = 1,
      biDrvs =
        lib.biMap [
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          busyboxStage0,
          llvmStage0
        ]
    },

  # 2
  muslStage2,
  gnumakeStage2,
  ccacheBin,
  m4Stage2,
  busyboxStage1,
  llvmStage1,
  bisonStage2 | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = 2,
      biDrvs =
        lib.biMap [
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          busyboxStage1,
          llvmStage1,
        ]
    },

  # final
  musl,
  gnumake,
  ccacheBin,
  m4,
  busyboxStage2,
  llvmStage2,

  bison | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
        lib.biMap [
          musl,
          gnumake,
          ccacheBin,
          m4,
          busyboxStage2,
          llvmStage2,
        ]
    }
}
