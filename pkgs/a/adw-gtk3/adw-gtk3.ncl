{
  lib,
  drvs,
  adwGtk3 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/lassekongo83/adw-gtk3/archive/refs/tags/v6.2.tar.gz",
      sha256sum = "ef554d3d0e7ee65833150b9af4fb2efeadd666c739d3de7b2e26ecaeb9bb026a"
    },

    biDrvs = [
      drvs.sassc
    ]
  }
}
