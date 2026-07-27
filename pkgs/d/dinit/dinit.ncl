{
  lib,
  drvs,
  dinit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.22.1.tar.gz",
      sha256sum = "8907d4f668259c4f66d9d2c7cbbb55d455c28dc433596ab29005d589cb572e1e"
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
    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/share/fish/completions",
      "install -m0755 contrib/shell-completion/fish/dinitctl.fish ${DEST}/usr/share/fish/completions/",
    ],
    biDrvs = [
      drvs.m4,
      drvs.pkgconfMeson,
      drvs.libcap,
      drvs.linuxHeaders,
    ],
  }
}
