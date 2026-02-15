{
  lib,
  drvs,
  libx86emu | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/wfeldt/libx86emu/archive/refs/tags/3.7.tar.gz",
      sha256sum = "03754aede79530baa0e862e1aad5527e9c1bd3371736b1ab5a2bc769e4a3d680",
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
    ],
    preConfigurePhase = [
      "echo 3.7 > VERSION",
      m%"sed -i 's@all: changelog shared@all: shared@g' ${SRC}/Makefile"%,
      m%"sed -i 's@-shared@-static@g' ${SRC}/Makefile"%,
    ],
    buildPhase = [
      "%{import "build.sh" as 'Text}",
    ],
    installPhase = [
      "%{import "install.sh" as 'Text}",
    ],
    # biDrvs = [
    #     drvs.perl,
    # ],
  }
}
