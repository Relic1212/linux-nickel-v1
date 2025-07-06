{
  lib,
  linuxHeaders,

  heirloom | lib.MakePackage = {
    singleSource = {
      uri = "https://sourceforge.net/projects/heirloom/files/heirloom/070715/heirloom-070715.tar.bz2",
      sha256sum = "eb33f70bcc019b1d0e0a41f1d7552d45c57a16272e4e1c48634ec3e44496a30f",
    },
    extraMakeArgs = [
      # m%"LCURS="-lncurses" "%,
      # "HOSTCC=\"clang -static\"",
      "CC=\"${CC}\"",
      # "TTYGRP=\"\"",
      "ROOT=${DEST}",
      # "DEFBIN=/usr/bin",
      # "SV3BIN=/usr/bin",
      # "S42BIN=/usr/bin",
      # "SUSBIN=/usr/bin",
      # "SU3BIN=/usr/bin"
    ],
    extraMakeInstallArgs = extraMakeArgs,
    biDrvs =
      lib.biMap [
        linuxHeaders,
      ],
  }
}
