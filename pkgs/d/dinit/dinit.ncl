{
  lib,
  drvs,
  dinit | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/davmac314/dinit/archive/refs/tags/v0.23.0.tar.gz",
      sha256sum = "911ed52b78ce4950824623d58826b88a839748e18ef837a234d50db6d83972e2"
    },

    extraMakeArgs = [
      "SBINDIR=/usr/bin",
      "SYSCONTROLSOCKET=/dev/dinitctl",
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
