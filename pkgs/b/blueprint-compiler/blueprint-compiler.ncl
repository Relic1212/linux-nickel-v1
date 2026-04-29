{
  lib,
  drvs,
  blueprintCompiler | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.18.0/blueprint-compiler-0.18.0.tar.gz",
      sha256sum = "51aa472ecd7bd4b32b8baa7ae6768b19810793d4a2a1aba39c5b31b0170cb258"
    }
  }
}
