{
  lib,
  drvs,
  psmisc | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.com/psmisc/psmisc/-/archive/v23.7/psmisc-v23.7.tar.gz",
      sha256sum = "8f2526ce7ac6ef4976454cd63095fa10e467ef745cf33dc4f91df0bd7b10b905"
    },
    biDrvs = [
      drvs.gettext,
      drvs.ncurses,
      drvs.linuxHeaders,
    ],
    separateBuildDir = false,

    preConfigurePhase = [
      "./autogen.sh",
      # m%"
      # echo "
      # all:
      #   true
      # " > ${SRC}/po/Makefile
      # "%
    ],

    extraConfigureFlags = [
      "--disable-nls"
    ],
  }
}
