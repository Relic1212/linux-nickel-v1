{
  pkgs,
  lib,
  # base
  _bisonBase | lib.AutotoolsPackage = {
    baseName | default = "bison",
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
          pkgs.muslStage1,
          pkgs.gnumakeStage1,
          pkgs.ccacheBin,
          pkgs.m4Stage1,
          pkgs.busyboxStage0,
          pkgs.llvmStage0
        ]
    },

  # 2

  bisonStage2 | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = 2,
      biDrvs =
        lib.biMap [
          pkgs.muslStage2,
          pkgs.gnumakeStage2,
          pkgs.ccacheBin,
          pkgs.m4Stage2,
          pkgs.busyboxStage1,
          pkgs.llvmStage1,
        ]
    },

  # final

  bison | lib.AutotoolsPackage =
    _bisonBase
    & {
      stage = -1,
      utilsProviders = [],
      baseBuildinputPackages = [],
      biDrvs =
        lib.biMap [
          pkgs.musl,
          pkgs.gnumake,
          pkgs.ccacheBin,
          pkgs.m4,
          pkgs.busyboxStage2,
          pkgs.llvmStage2,
        ]
    }
}
