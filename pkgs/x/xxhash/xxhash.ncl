{
  lib,
  xxhash | lib.MakePackage = {
    name = "xxhash",
    singleSource = {
      uri = "https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.2.tar.gz",
      sha256sum = "baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4",
    },
    buildDir = "${SRC}",
  }
}
