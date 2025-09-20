{
  lib,
  drvs,
  bsdutils | lib.MesonPackage = {
    singleSource = {
      uri = "https://codeberg.org/dcantrell/bsdutils/archive/7e38401ed3f5c23dd81a278dce796dabf264781a.tar.gz",
      sha256sum = "7706a2d3043e66b05a0f26a1dc2304814a807b84dc69e9d188a2df73dbf7aaf2",
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
    extraMesonArgs = [
      "-Dstatic_fts=true",
      "-Dstatic_rpmatch=true",
      "-Dcolor_ls=true",
      "-Dlibcrypto=enabled",
      "-Dlibedit=enabled",
    ],
    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "-lfts",
    #     "-lrpmatch",
    #   ]
    # },
    postInstallPhase = [
      #   "rm -r ${DEST}/usr/man1",
      # "rm -r ${DEST}/usr/bin/cp",
    ]
  }
}
