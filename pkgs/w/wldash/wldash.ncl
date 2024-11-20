{
  lib,
  drvs,

  wldash | lib.CargoPackage
    =
      let j = import "wldash-crates.json"
      in
      let _crates = lib.functions.filterCrates j
      in
      {
        singleSource = {
          uri = "https://git.sr.ht/~kennylevinsen/wldash/archive/v0.3.0.tar.gz",
          sha256sum = "05ab0b90d6bdc46ef8768e5ed61094ca7fd4f5b938429c645a2e15cce5b96ea6"
        },
        crates = _crates,
        biDrvs = [
          drvs.fontconfig,
          drvs.freetype,
          drvs.zlibNg,
          drvs.gperf,
          drvs.pixman,
          drvs.wayland,
          drvs.waylandProtocols,
          drvs.libffi,
          drvs.libxkbcommon,
          drvs.expat,
          drvs.linuxHeaders,
          drvs.alsaLibs,
          drvs.dbus,
        ],
        release = false,
        extraCargoFlags = [
          "--no-default-features",
          "--features alsa-widget,yaml-cfg,json-cfg",
        ]
      }
}
