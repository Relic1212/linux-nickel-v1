{
  lib,
  drvs,
  libblockdev | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/storaged-project/libblockdev/archive/refs/tags/3.4.0.tar.gz",
      sha256sum = "7cb0b4018600ab82d1d1f00e46c1b1d7a0cdab8f4682952dd9dba1ce7f6ebed4"
    },
    biDrvs = [
      drvs.autoconfArchive,
      drvs.glib,
      drvs.kmod,
      drvs.libffi,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.openssl,
      drvs.pcre2,
      drvs.pythonFull,
      drvs.utilLinux,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
    ]
  }
}
