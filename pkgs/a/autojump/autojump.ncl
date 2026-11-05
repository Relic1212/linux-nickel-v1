{
  lib,
  drvs,
  autojump | lib.Package = {
    singleSource = {
      uri = "https://github.com/wting/autojump/archive/ee21082751da739c65fe0ec2d02ca95d4266aebc.tar.gz",
      sha256sum = "7e2f38e0257aed1573c13472616796145b9339359ca2585cf144a6d888a435e7",
    },

    extraEnv = {
      SHELL = "zsh",
      # HOME = "/tmp/home",
    },
    separateBuildDir = false,
    # preConfigurePhase = [
    #   "mkdir $HOME",
    # ],
    installPhase = [
      "./install.py --help",
      "./install.py -d ${DEST} -p usr",
    ],
    biDrvs = [
      drvs.pythonFull,
    ],
  }
}
