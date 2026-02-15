{
  lib,
  drvs,
  wev | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~sircmpwn/wev/archive/1.1.0.tar.gz",
      sha256sum = "89b8d9bc756631795ee91c99a0d5b0877c9f5c3acfe81f77a2b69ecfc15daf16"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
    ],
  }
}
