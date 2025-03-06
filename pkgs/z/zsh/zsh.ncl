{
  lib,
  drvs,
  zsh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.funet.fi/pub/unix/shells/zsh/zsh-5.9.tar.xz",
      sha256sum = "9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5",
    },
    biDrvs = [
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.libcap,
      drvs.bison,
      drvs.pkgconf,
      (drvs.diffutils & { priority = 1 }),
    ],

    # copied from OE
    extraConfigureFlags = [
      "--with-term-lib='ncursesw ncurses'",
      "--with-tcsetpgrp",
      # "--enable-cap",
      "--enable-multibyte",
      "--enable-libc-musl",
      "--disable-dynamic-nss",
      "--disable-dynamic",
      "--enable-multibyte",
    ],
  },
}
