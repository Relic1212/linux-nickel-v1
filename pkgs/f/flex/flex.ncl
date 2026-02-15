{
  lib,
  drvs,
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
      biDrvs = [
        drvs.llvmStage0,
        drvs.muslStage1,
        drvs.gnumakeStage1,
        drvs.ccacheBin,
        drvs.m4Stage1,
        drvs.busyboxStage0,
      ]
    },

  #2

  flexStage2 | lib.AutotoolsPackage =
    _flexBase
    & {
      stage = 2,
      biDrvs = [
        drvs.llvmStage1,
        drvs.muslStage2,
        drvs.gnumakeStage2,
        drvs.ccacheBin,
        drvs.m4Stage2,
        drvs.busyboxStage1,
      ]
    },
  #final

  flex | lib.AutomakePackage =
    _flexBase
    & {
      stage = -1,

      # utilsProviders = [],
      # baseBuildinputPackages = [],
      biDrvs = [
        drvs.gettext,
        # drvs.llvm,
        # drvs.musl,
        # drvs.gnumake,
        # drvs.ccacheBin,
        # drvs.m4,
        # drvs.busybox,
      ]
    },
  flexLex | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "ln -s flex lex",
    ]
  }
}
