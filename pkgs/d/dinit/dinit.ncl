{
  lib,
  drvs,
  dinit | lib.MesonPackage = {
    singleSource = {

      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.19.4.tar.gz",
      sha256sum = "3c0f624eb958f8e884631be4ef687da1e475ebaa6241e7ee330b864e6cd9e30b"
    },

    extraMesonArgs = [
      "-Ddinit-sbindir=/usr/bin"
    ],
    biDrvs = [
      drvs.m4
    ],
    preConfigurePhase = [
      m%"sed -i 's@\/sbin\/swapoff@\/usr\/bin/swapoff@g' ${SRC}/src/shutdown.cc"%,
      m%"sed -i 's@\/bin\/umount@\/usr\/bin/umount@g' ${SRC}/src/shutdown.cc"%,
    ]
  }
}
