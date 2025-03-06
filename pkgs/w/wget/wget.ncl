{
  lib,
  drvs,
  wget2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.wayne.edu/gnu/wget/wget2-2.1.0.tar.gz",
      sha256sum = "a05dc5191c6bad9313fd6db2777a78f5527ba4774f665d5d69f5a7461b49e2e7"
    },
    biDrvs = [
      drvs.ncurses,
      drvs.readline,
      drvs.openssl,
      drvs.pkgconf,
      drvs.linuxHeaders
    ]
  }
}
& {
  lib,
  drvs,
  wget | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://ftp.wayne.edu/gnu/wget/wget-1.25.0.tar.gz",
      sha256sum = "766e48423e79359ea31e41db9e5c289675947a7fcf2efdcedb726ac9d0da3784"
    },
    biDrvs = [
      drvs.ncurses,
      drvs.readline,
      drvs.openssl,
      drvs.pkgconf,
      drvs.linuxHeaders,
      drvs.libpsl,
      drvs.zlibNg,
    ],
    extraConfigureFlags = [
      "--with-ssl=openssl",
    ]
  }
}
