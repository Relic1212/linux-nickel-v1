{
  lib,
  drvs,
  cryptsetup | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.com/cryptsetup/cryptsetup/-/archive/v2.8.7/cryptsetup-v2.8.7.tar.bz2",
      sha256sum = "95be59489347f0a19ce0fe1149f686073bbdfebc3b2570367fc4df237e86f0bf",
    },
    extraMesonArgs = [
      "-Dasciidoc=disabled",
      "-Dnls=false",
      "-Dssh-token=false",
    ],
    biDrvs = [
      drvs.bash,
      drvs.linuxHeaders,
      drvs.popt,
    ],
    pDrvs = [
      drvs.utilLinux,
      drvs.jsonC,
      drvs.lvm2,
      drvs.openssl,
    ],
    preConfigurePhase = [
      m%"sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${SRC}/tests/generate-symbols-list"%
    ],
  }
}
