{
  lib,

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
  busyboxStage0,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1 =
    _m4Base
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
        ]
    },

  #2
  busyboxStage1,
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  m4Stage2 =
    _m4Base
    & {
      stage = 2,
      buildInputs =
        lib.biMap [
          busyboxStage1,
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
        ]
    },

  #final
  busyboxStage2,
  llvmStage2,
  musl,
  gnumake,
  m4 =
    _m4Base
    & {
      stage = -1,

      utilsProviders = lib.biMap [],
      baseBuildinputPackages = lib.biMap [],
      buildInputs =
        lib.biMap [
          busyboxStage2,
          llvmStage2,
          musl,
          gnumake,
          ccacheBin,
        ]
    },
}
