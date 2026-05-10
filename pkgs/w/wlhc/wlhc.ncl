{
  lib,
  drvs,
  wlhc | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~whynothugo/wlhc/archive/5fad1caf0bce2f565f7bf071b37987f9ecc8168d.tar.gz",
      sha256sum = "f347aaa27f482b089e41363ebc324f806f10360c8d2e2d67692e8cbf5df260fe",
    },
    buildEnv._isLlvm = false,
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
    ],
    biDrvs = [
      drvs.binutils,
      drvs.qbe,
      drvs.harec,
      drvs.scdoc,
      drvs.hare,
      drvs.hareWayland,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
      drvs.hareXml,
      drvs.pkgconfMeson,
      drvs.wlrProtocols,
      drvs.hareEv,
    ],
  }
}
