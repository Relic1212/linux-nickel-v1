{
  lib,
  drvs,
  e2fsprogs | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.47.1/e2fsprogs-1.47.1.tar.gz",
      sha256sum = "0d2e0bf80935c3392b73a60dbff82d8a6ef7ea88b806c2eea964b6837d3fd6c2",
    },
    extraConfigureFlags = [
      "ac_cv_func_llseek='yes'",
      "--disable-e2initrd-helper",
      "--disable-libuuid",
      "--disable-libblkid",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.pkgconfMeson,
      drvs.utilLinux,
      drvs.ncurses,
    ],
    # postInstallPhase = [
    #   "rm ${DEST}/usr/lib/libblkid.a",
    #   "rm ${DEST}/usr/lib/libuuid.a",
    #   "rm ${DEST}/usr/lib/pkgconfig/blkid.pc",
    #   "rm ${DEST}/usr/lib/pkgconfig/uuid.pc",
    # ]
  }
}
