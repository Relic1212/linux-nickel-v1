{
  lib,
  drvs,
  dinit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.20.0.tar.gz",
      sha256sum = "cd75b572a2eab4a9bd0610a2bb8cc154da7e80074e61cb1059a996dfd977baae"
    },

    extraMakeArgs = [
      "SBINDIR=/usr/bin",
    ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],
    preConfigurePhase = [
      m%"sed -i 's@\/sbin\/swapoff@\/usr\/bin/swapoff@g' ${SRC}/src/shutdown.cc"%,
      m%"sed -i 's@\/bin\/umount@\/usr\/bin/umount@g' ${SRC}/src/shutdown.cc"%,
    ],
    biDrvs = [
      drvs.m4,
      drvs.pkgconfMeson,
      drvs.libcap,
      drvs.linuxHeaders,
    ],
  }
}
