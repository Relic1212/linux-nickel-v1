{
  lib,
  lz4 | lib.MesonPackage = {
    name = "lz4",

    singleSource = {
      uri = "https://github.com/lz4/lz4/releases/download/v1.10.0/lz4-1.10.0.tar.gz",
      sha256sum = "537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"
    },
    # extraMakeArgs=[ "BUILD_SHARED=no"],
    buildDir = "${SRC}",
    extraMesonArgs = [
      "-Dprograms=true"
    ],
    mesonArgs,
    configurePhase = [
      "meson setup %{std.string.join "\\\n\t" mesonArgs} . ${SRC}/build/meson"
    ],
  }
}
