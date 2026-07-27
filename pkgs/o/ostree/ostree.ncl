{
  lib,
  drvs,
  ostree | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/ostreedev/ostree/releases/download/v2024.8/libostree-2024.8.tar.xz",
      sha256sum = "e2136e116669f114ff7349f12e299f63c0bece733451649414a8dcd85b863c3f",
    },

    biDrvs = [
      drvs.bison,
      drvs.pkgconf,
      drvs.pythonFull,
      drvs.m4,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.gpgme,
      drvs.zstd,
      drvs.lz4,
      drvs.xz,
      drvs.e2fsprogs,
      drvs.curl,
      drvs.libsoup,
      drvs.fuse,
    ],
    extraConfigureFlags = [
      "--without-avahi",
      "--disable-glibtest",
      "--without-libsystemd",
      "--without-libmount",
      "--with-gpgme",
      # "--without-soup",
      "--enable-http2",
      "--without-composefs",
      "--with-openssl",
      "--with-curl",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lzstd",
        "-llz4",
      ],
    },
  }
}
& {
  lib,
  drvs,
  sqlite | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.sqlite.org/2024/sqlite-autoconf-3470200.tar.gz",
      sha256sum = "f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b"
    }
  }
}
