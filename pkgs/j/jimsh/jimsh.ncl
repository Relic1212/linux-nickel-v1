{
  lib,
  drvs,
  jimsh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/msteveb/jimtcl/archive/refs/tags/0.84.tar.gz",
      sha256sum = "435095b436b38b96dd85e8cda13878144813bf52066057f76368db178dd8fea2",
    },
    extraEnv = {
      CC_FOR_BUILD = ["clang", "-static"],
    },
    configureFlags = [
      "--prefix=/usr",
    ],
  }
}
