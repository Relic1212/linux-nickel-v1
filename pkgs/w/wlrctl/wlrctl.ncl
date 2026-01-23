{
  lib,
  drvs,
  wlrctl | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~brocellous/wlrctl/archive/v0.2.2.tar.gz",
      sha256sum = "b5b3836091c41de09a832df1e5eb4747841d7ae670367e413487d5be7a5f2849"
    },

    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.linuxHeaders,
    ],
  }
}
