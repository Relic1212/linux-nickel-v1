{
  lib,
  drvs,
  blueprintCompiler | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.18.0/blueprint-compiler-0.18.0.tar.gz",
      # sha256sum = "51aa472ecd7bd4b32b8baa7ae6768b19810793d4a2a1aba39c5b31b0170cb258",

      uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/v0.20.4/blueprint-compiler-v0.20.4.tar.bz2",
      sha256sum = "37c1f50f64108af83aa5dfeb182147e0731c617c996ad6cf8dcaf2902d555219",
    }
  },
  blueprintCompiler19 | lib.MesonPackage = {
    singleSource = {

      uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/0.19.0/blueprint-compiler-0.19.0.tar.bz2",
      sha256sum = "c3d5ba91e6e952b6b2e9540eb4328520482c3b8f5f53f3269f047a85bcda349c",
    }
  },
  blueprintCompiler22 | lib.MesonPackage = {
    singleSource = {

      uri = "https://gitlab.gnome.org/GNOME/blueprint-compiler/-/archive/v0.22.2/blueprint-compiler-v0.22.2.tar.bz2?ref_type=tags",
      sha256sum = "d8d7071f7ea957a2a4974514576e3282e3641d05c856bbc9454b78cbe2975749",
    }
  }
}
