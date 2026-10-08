{
  lib,
  drvs,
  cryptsetup | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.com/cryptsetup/cryptsetup/-/archive/v2.8.8/cryptsetup-v2.8.8.tar.bz2",
      sha256sum = "f0ce78c01d88d0795b4e6f17a40f452b0c9aceb70346a62cdf4d52d47eaf0b2c",
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
