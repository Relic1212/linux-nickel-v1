{
  lib,
  drvs,
  _waylandProtocols | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.37/wayland-protocols-1.37.tar.gz",
      # sha256sum = "c3b215084eb4cf318415533554c2c2714e58ed75847d7c3a8e50923215ffbbf3",

      # uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.45/wayland-protocols-1.45.tar.gz",
      # sha256sum = "460dad72a6c84b2a7d80745bee43d96ba117f4e3dfc4d7c45f83f66469ea27df",

      # uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.47/wayland-protocols-1.47.tar.gz",
      # sha256sum = "dd2df14ab5f41038257aaedcc4b5fb9ac0ee018f3f0f94af9097028e60d33223",

      uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.49/wayland-protocols-1.49.tar.bz2",
      sha256sum = "7330d2d8fbda81991548738e81da493829bc55db2daf1ae15b9d4952e4d7d83b"
    },
    biDrvs = [
      drvs.wayland,
      drvs.linuxHeaders,
    ],
    extraMesonArgs = ["-Dtests=false"],
  }
}
& {
  lib,
  drvs,
  _waylandProtocols,
  # _waylandProtocols139 | lib.MesonPackage =
  #   _waylandProtocols
  #   & {
  #     singleSource | priority 1 = {
  #       uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.39/wayland-protocols-1.39.tar.gz",
  #       sha256sum = "42c16435dfc83f320ff727b6d446bb0d4feb361dc11796a2c5d3c0fb6532a517",
  #     },
  #   },
  # _waylandProtocols141 | lib.MesonPackage =
  #   _waylandProtocols
  #   & {
  #     singleSource | priority 1 = {
  #       uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.41/wayland-protocols-1.41.tar.gz",
  #       sha256sum = "f25b0d00f3c610158b00b57b1b7b6e59c4bfd4d91aed46f24d9eba7acf220788",
  #     },
  #   },
  _waylandProtocols143 =
    _waylandProtocols
    & {
      singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.43/wayland-protocols-1.43.tar.gz",
        sha256sum = "05fc0ff0c6b3081549d8f81c6b584076a20be18e8c2b9be65ae09ce05e5aea9e",
      },
    },

  _waylandProtocols145 =
    _waylandProtocols
    & {
      singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/archive/1.45/wayland-protocols-1.45.tar.gz",
        sha256sum = "460dad72a6c84b2a7d80745bee43d96ba117f4e3dfc4d7c45f83f66469ea27df",
      },
    },

  waylandProtocols = _waylandProtocols,
  # waylandProtocols145 = _waylandProtocols145,
}
