{
  lib,
  drvs,
  cosmicExtAlternativeStartup | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Drakulix/cosmic-ext-alternative-startup/archive/8ceda00197c7ec0905cf1dccdc2d67d738e45417.tar.gz",
      sha256sum = "c5923f30dea9a71dc769927bc1abaab63dcbfc32180fd9a2c84ba04d6c0f7efd",
    },
    enableSccache = false,
    crates = lib.functions.filterCrates (import "cosmic-ext-alternative-startup-crates.json")
  },

  cosmicExtExtraSessions | lib.Package = {
    singleSource = {
      uri = "https://github.com/Drakulix/cosmic-ext-extra-sessions/archive/66e065728d81eab86171e542dad08fb628c88494.tar.gz",
      sha256sum = "efdf87219f24a5214da0b41e9447229a916958b74c11123ab3a416cad65150a2"
    },

    installPhase = [
      "cd ${SRC}/niri",
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 start-cosmic-ext-niri ${DEST}/usr/bin",
      "chmod +x ${DEST}/usr/bin",
      "install -dm0755 ${DEST}/usr/share/wayland-sessions/",
      "install -m0755 cosmic-ext-niri.desktop ${DEST}/usr/share/wayland-sessions/",
      m%"sed -i 's|usr/local/bin|usr/local/bin|g' ${DEST}/usr/share/wayland-sessions/cosmic-ext-niri.desktop"%,
    ]
  }
}
