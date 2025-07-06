{
  lib,
  fontconfig,
  freetype,
  zlibNg,
  gperf,
  pixman,
  wayland,
  waylandProtocols,
  libffi,
  libxkbcommon,
  expat,
  linuxHeaders,
  alsaLibs,
  dbus,

  wldash | lib.CargoPackage =
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
      biDrvs =
        lib.biMap [
          fontconfig,
          freetype,
          zlibNg,
          gperf,
          pixman,
          wayland,
          waylandProtocols,
          libffi,
          libxkbcommon,
          expat,
          linuxHeaders,
          alsaLibs,
          dbus,
        ],
      release = false,
      extraCargoFlags = [
        "--no-default-features",
        "--features alsa-widget,yaml-cfg,json-cfg",
      ]
    }
}
