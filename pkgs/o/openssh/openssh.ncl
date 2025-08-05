{
  lib,
  drvs,
  openssh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.9p2.tar.gz",
      sha256sum = "91aadb603e08cc285eddf965e1199d02585fa94d994d6cae5b41e1721e215673"
    },
    separateBuildDir = false,
    biDrvs = [
      drvs.openssl,
      drvs.linuxHeaders,
      drvs.zlibNg,
    ]
  }
}
