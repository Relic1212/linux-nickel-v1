{
  lib,
  flex,
  bison,
  openssl,
  ncurses,
  libedit,
  muslFts,
  muslRpmatch,
  libxo,
  m4,
  linuxHeaders,

  bsdutils | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/dcantrell/bsdutils/releases/download/v13.1/bsdutils-13.1.tar.xz",
      sha256sum = "96b43f3d148abdcc2f4ff8f743a30b09f61540b151f7c838643e16fb18bf05ea",
    },
    biDrvs =
      lib.biMap [
        flex,
        bison,
        openssl,
        ncurses,
        libedit,
        muslFts,
        muslRpmatch,
        libxo,
        m4,
        linuxHeaders,
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
