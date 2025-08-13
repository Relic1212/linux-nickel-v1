{
  lib,
  drvs,
  fuseOverlayfs | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/containers/fuse-overlayfs/archive/refs/tags/v1.15.tar.gz",
      sha256sum = "e4fbbdacbeffb560715e6c74c128aee07a7053a1fec78dc904bcc0a88e2efd67"
    },
    biDrvs = [
      drvs.fuse,
      drvs.linuxHeaders,
    ]
  }
}
