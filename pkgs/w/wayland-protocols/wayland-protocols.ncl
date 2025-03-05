{
  lib,
  pkgs,
  waylandProtocols | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.37/wayland-protocols-1.37.tar.gz",
        sha256sum = "c3b215084eb4cf318415533554c2c2714e58ed75847d7c3a8e50923215ffbbf3",
      },
      biDrvs =
        lib.biMap [
          pkgs.wayland,
          pkgs.linuxHeaders,
        ],
      extraMesonArgs = ["-Dtests=false"],
    }
}
& 
{
  lib,
  drvs,
  waylandProtocols,
  "waylandProtocols-1.39"|lib.MesonPackage = waylandProtocols & {
singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.39/wayland-protocols-1.39.tar.gz",
        sha256sum = "42c16435dfc83f320ff727b6d446bb0d4feb361dc11796a2c5d3c0fb6532a517",
      },
  },
 "waylandProtocols-1.41"|lib.MesonPackage = waylandProtocols & {
singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.41/wayland-protocols-1.41.tar.gz",
        sha256sum = "f25b0d00f3c610158b00b57b1b7b6e59c4bfd4d91aed46f24d9eba7acf220788",
      },
  },




}