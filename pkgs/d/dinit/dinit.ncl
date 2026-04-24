{
  lib,
  drvs,
  dinit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.21.0.tar.gz",
      sha256sum = "2621949e8d25f5f1a27196f68f0487cdfbd93fb3d21daf6093b2cd27c5a987be"
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
