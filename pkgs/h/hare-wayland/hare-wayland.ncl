{
  lib,
  drvs,
  hareWayland | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-wayland/archive/0.26.0.1.tar.gz",
      sha256sum = "262755c145cc32e3c4b9a6556139c9d97f9160ed41329e6283b947d52cc8753c",
    },
    # isLlvm = false,
    buildEnv._isLlvm = false,
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # llvmProvider,
      drvs.binutils & { priority = -1 },
      drvs.qbe,
      drvs.harec,
      drvs.scdoc,
      drvs.hare,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
      drvs.hareXml,
      drvs.pkgconfMeson,
    ],
  },

  hareXml | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/hare-xml/archive/0.25.2.0.tar.gz",
      sha256sum = "76c2d6321524b8065cc78874e9677600949dc4bff11bb75c9e07c4180093cfbb",
    },
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    # llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.qbe,
      drvs.harec,
      # drvs.scdoc,
      drvs.hare,
    ],
  },
}
