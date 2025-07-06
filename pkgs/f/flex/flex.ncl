{
  lib,
  llvmStage0,
  muslStage1,
  gnumakeStage1,
  ccacheBin,
  m4Stage1,
  busyboxStage0,

  ## base
  _flexBase | lib.AutotoolsPackage = {

    baseName | priority -10 = "flex",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz",
          sha256sum = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
        }
      }
    ],
    extraConfigureFlags = [
      "--without-libintl-prefix",
      "--disable-nls",
    ],
    # buildDir = "${SRC}"
  },
  ##

  flexStage1 | lib.AutotoolsPackage =
    _flexBase
    & {
      stage = 1,
      biDrvs =
        lib.biMap [
          llvmStage0,
          muslStage1,
          gnumakeStage1,
          ccacheBin,
          m4Stage1,
          busyboxStage0,
        ]
    },

  #2
  llvmStage1,
  muslStage2,
  gnumakeStage2,
  ccacheBin,
  m4Stage2,
  busyboxStage1,

  flexStage2 | lib.AutotoolsPackage =
    _flexBase
    & {
      stage = 2,
      biDrvs =
        lib.biMap [
          llvmStage1,
          muslStage2,
          gnumakeStage2,
          ccacheBin,
          m4Stage2,
          busyboxStage1,
        ]
    },
  #final
  gettext,
  flex | lib.AutomakePackage =
    _flexBase
    & {
      stage = -1,

      # utilsProviders = [],
      # baseBuildinputPackages = [],
      biDrvs =
        lib.biMap [
          gettext,
          # llvm,
          # musl,
          # gnumake,
          # ccacheBin,
          # m4,
          # busybox,
        ]
    }
}
