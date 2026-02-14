{
  lib,
  drvs,

  hyprwaylandScanner | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {

      uri = "https://github.com/hyprwm/hyprwayland-scanner/archive/refs/tags/v0.4.5.tar.gz",
      sha256sum = "2125d279eea106e3e6c8dc9fa15181c75d67467b5352d24e2a07903b10abad62"
    },
    biDrvs = [
      drvs.pugixml,
    ]
  },

  pugixml | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/zeux/pugixml/releases/download/v1.14/pugixml-1.14.tar.gz",
      sha256sum = "2f10e276870c64b1db6809050a75e11a897a8d7456c4be5c6b2e35a11168a015"
    }
  },
}
