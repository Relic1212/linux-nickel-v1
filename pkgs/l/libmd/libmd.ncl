{
  lib,
  libmd | lib.AutotoolsPackage
    = {
      name = "libmd",
      singleSource = {
        uri = "https://libbsd.freedesktop.org/releases/libmd-1.1.0.tar.xz",
        sha256sum = "1bd6aa42275313af3141c7cf2e5b964e8b1fd488025caf2f971f43b00776b332",
      }
    }
}
