{
  lib,
  zstd | lib.MesonPackage = {
    #name = "zstd",
    singleSource = {
      uri = "https://github.com/facebook/zstd/archive/v1.5.6.tar.gz",
      sha256sum = "30f35f71c1203369dc979ecde0400ffea93c27391bfd2ac5a9715d2173d92ff7",
    },
    mesonArgs,
    configurePhase = [
      "meson setup %{std.string.join "\\\n\t" mesonArgs} . ${SRC}/build/meson"
    ],
  }
}
