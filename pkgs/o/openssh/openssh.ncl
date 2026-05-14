{
  lib,
  drvs,
  openssh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz",
      sha256sum = "ccc42c0419937959263fa1dbd16dafc18c56b984c03562d2937ce56a60f798b2"
    },
    separateBuildDir = false,
    extraConfigureFlags = [
      "--with-mantype=man",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.zlibNg,
      drvs.openssl,
    ]
  }
}
