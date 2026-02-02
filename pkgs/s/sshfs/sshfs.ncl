{
  lib,
  drvs,
  sshfs | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/libfuse/sshfs/archive/refs/tags/sshfs-3.7.5.tar.gz",
      sha256sum = "99d294101f1b8997653a84c35674c2e50c18323ea2c449412c0ed46b9d31ac35"
    },
    biDrvs = [
      drvs.fuse,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.linuxHeaders,
      drvs.coreutils & { priority = 1 },
      drvs.docutils,
    ],
  }
}
