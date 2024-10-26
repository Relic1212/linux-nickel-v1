{
  lib,
  hwData | lib.AutotoolsPackage
    = {
      name = "hwdata",
      singleSource = {
        uri = "https://github.com/vcrhonek/hwdata/archive/refs/tags/v0.387.tar.gz",
        sha256sum = "8c6be8f0863a8ff5c83b2c46aa525b503b30d42792ed57891c40849de543e1ee"
      },
      buildDir = "${SRC}",
      extraConfigureFlags = [
        "--disable-blacklist"
      ]
    }
}
