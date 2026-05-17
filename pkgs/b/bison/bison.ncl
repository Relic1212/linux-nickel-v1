{
  drvs,
  lib,
  # base
  _bisonBase | lib.AutotoolsPackage = {
    baseName | priority -1 = "bison",
    sourceInputs = [
      {
        src = { uri = "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz", sha256sum = "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2" }
      }
    ],
  },
  # 1

  # bisonStage1 | lib.AutotoolsPackage =
  #   _bisonBase
  #   & {
  #     stage = 1,
  #     biDrvs = [
  #       drvs.muslStage1,
  #       drvs.gnumakeStage1,
  #       drvs.ccacheBin,
  #       drvs.m4Stage1,
  #       drvs.busyboxStage0,
  #       drvs.llvmStage0,
  #     ]
  #   },

  # 2

  bisonStage2 | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = 2,
      biDrvs = [
        drvs.muslStage2,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
        drvs.m4Stage2,
        drvs.busyboxStage1,
        drvs.llvmStage1,
      ]
    },

  # final

  bison | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs = [
        drvs.musl,
        drvs.gnumake,
        drvs.ccacheBin,
        drvs.m4,
        drvs.busyboxStage2,
        drvs.llvmStage2,
      ]
    }
}
