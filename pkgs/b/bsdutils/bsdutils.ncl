{
  lib,
  drvs,
  bsdutils | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/dcantrell/bsdutils/releases/download/v13.1/bsdutils-13.1.tar.xz",
      sha256sum = "96b43f3d148abdcc2f4ff8f743a30b09f61540b151f7c838643e16fb18bf05ea",
    },
    biDrvs = [
      drvs.flex,
      drvs.bison,
      drvs.openssl,
      drvs.ncurses,
      drvs.libedit,
      drvs.muslFts,
      drvs.muslRpmatch,
      drvs.libxo,
      drvs.m4,
      drvs.linuxHeaders,
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lfts",
        "-lrpmatch",
      ]
    },
    postInstallPhase = [
      "rm -r ${DEST}/usr/man1",
    ]
  }
}
