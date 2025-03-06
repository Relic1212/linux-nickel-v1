{
  lib,
  drvs,
  heirloomNg | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/Projeto-Pindorama/heirloom-ng/archive/7ea2bf824dfedc5dfd35bd2ef421dc4201f5638b.zip",
      sha256sum = "d4c89896520ff78d08c59e560a00ded272b84092d867d12ba6cd8acc58e097f9"

      # uri="https://github.com/Projeto-Pindorama/heirloom-ng/archive/refs/tags/230503.tar.gz",
      # sha256sum="06d43edb31631469ec0b70b68b915efefc72a27d8ccd645bebef560b7497bd97"
    },
    biDrvs = [
      drvs.pigz,
      drvs.bison,
      drvs.flex,
      drvs.libarchive,
      drvs.zlibNg,
      drvs.m4,
      drvs.linuxHeaders,
      drvs.bzip2,
      drvs.ncurses,
      drvs.readline,
      drvs.bash,
      drvs.basefiles,
    ],
    extraEnv = {
      HOSTCC = ["clang", "-static"],
      DESTDIR = "/tmp/workdir/out/destdir",
      ROOT = "/tmp/workdir/out/destdir",
    },
    preConfigurePhase = [
      m%"
            sed -i \
                's@<langinfo.h>@<langinfo.h>\n#include	<sys/time.h>@g' \
                ${SRC}/date/date.c
            "%,
      m%"
            sed -i \
                's@sccs prt@@g' \
                ${SRC}/Makefile.mk
            "%,
    ],
    extraMakeArgs = [
      m%"LCURS="-lncurses" "%,
      "HOSTCC=\"clang -static\"",
      "TTYGRP=\"\"",
      "ROOT=${DEST}",
      # "DEFBIN=/usr/bin",
      # "SV3BIN=/usr/bin",
      # "S42BIN=/usr/bin",
      # "SUSBIN=/usr/bin",
      # "SU3BIN=/usr/bin"
    ],
    extraMakeInstallArgs = extraMakeArgs,
    # [
    #     "TTYGRP=\"\"",
    #     "ROOT=${DEST}",

    # ]
  }
}
