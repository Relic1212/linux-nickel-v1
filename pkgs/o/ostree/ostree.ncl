{
  lib,
  drvs,
  ostree | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/ostreedev/ostree/releases/download/v2024.8/libostree-2024.8.tar.xz",
        sha256sum = "e2136e116669f114ff7349f12e299f63c0bece733451649414a8dcd85b863c3f",
      },

      biDrvs = [
        drvs.bison,
        drvs.glib,
        drvs.pkgconf,
        drvs.pcre2,
        drvs.zlibNg,
        drvs.libffi,
        drvs.libarchive,
        drvs.xz,
        drvs.e2fsprogs,
        drvs.fuse,
        drvs.pythonFull,
        drvs.m4,
        drvs.linuxHeaders,
        drvs.zstd,
        drvs.lz4,
      ],
      extraConfigureFlags = [
        "--without-avahi",
        "--disable-glibtest",
        "--disable-http2",
        "--without-libsystemd",
        "--without-libmount",
        "--without-gpgme",
        "--without-soup",
        "--disable-http2",
        "--without-composefs",
      ],
      buildEnv = {
        EXTRA_LDFLAGS = [
          "-lzstd",
          "-llz4",
        ],
      },
    }
}
