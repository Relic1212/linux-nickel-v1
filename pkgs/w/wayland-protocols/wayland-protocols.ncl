{
  lib,
  pkgs,
  waylandProtocols | lib.MesonPackage
    = {
      name = "wayland-protocols",
      singleSource = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.37/wayland-protocols-1.37.tar.gz",
        sha256sum = "c3b215084eb4cf318415533554c2c2714e58ed75847d7c3a8e50923215ffbbf3",
      },
      biPkgs = [
        pkgs.wayland,
        pkgs.linuxHeaders,
      ],
      extraMesonArgs = ["-Dtests=false"],
    }
}
