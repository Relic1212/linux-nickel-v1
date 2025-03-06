{
  lib,
  drvs,
  wob | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/francma/wob/archive/refs/tags/0.15.1.tar.gz",
      sha256sum = "094f666e799a7fa0914192d041032f4e9a28a87486d024db80ade010988b218a"
    },
    biDrvs = [
      drvs.scdoc,
      drvs.linuxHeaders,
      drvs.expat,
      drvs.libffi,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.inih,
    ],
  }
}
