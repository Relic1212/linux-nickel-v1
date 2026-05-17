{
  lib,
  drvs,
  # base
  _m4Base | lib.AutotoolsPackage = {
    baseName = "m4",
    buildEnv = (lib.AutotoolsPackage.buildEnv & { LD = "lld" }),
    sourceInputs = [
      {
        src = {
          uri = "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz",
          sha256sum = "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
        }
      }
    ],
    # buildDir = "${SRC}",
  },
  ##

  # m4Stage1 =
  #   _m4Base
  #   & {
  #     stage = 1,
  #     buildInputs = [
  #       drvs.busyboxStage0,
  #       drvs.llvmStage0,
  #       drvs.muslStage1,
  #       drvs.gnumakeStage1,
  #       drvs.ccacheBin,
  #     ]
  #   },

  #2

  m4Stage2 =
    _m4Base
    & {
      stage = 2,
      buildInputs = [
        drvs.busyboxStage1,
        drvs.llvmStage1,
        drvs.muslStage2,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
      ]
    },

  #final

  m4 =
    _m4Base
    & {
      stage = -1,

      utilsProviders = [],
      baseBuildinputPackages = [],
      buildInputs = [
        drvs.busyboxStage2,
        drvs.llvmStage2,
        drvs.musl,
        drvs.gnumake,
        drvs.ccacheBin,
      ]
    },
}
