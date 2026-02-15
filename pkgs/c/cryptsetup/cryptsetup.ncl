{
  lib,
  drvs,
  cryptsetup | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.kernel.org/pub/linux/utils/cryptsetup/v2.8/cryptsetup-2.8.4.tar.xz",
      sha256sum = "443e46f8964c9acc780f455afbb8e23aa0e8ed7ec504cfc59e04f406fa1e8a83",
    },
    biDrvs = [
      drvs.utilLinux,
      drvs.jsonC,
      drvs.lvm2,
      drvs.pkgconf,
      drvs.openssl,
      drvs.bash,
      drvs.linuxHeaders,
      drvs.popt,
    ],
    preConfigurePhase = [
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tests/generate-symbols-list"%
    ],
    extraConfigureFlags = [
      "--disable-asciidoc",
      "--disable-nls",
      "--disable-ssh-token",
    ]
  }
}
