{
  lib,
  drvs,
  "libsigc++" | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/libsigc++/3.0/libsigc++-3.0.7.tar.xz",
        sha256sum = "bfbe91c0d094ea6bbc6cbd3909b7d98c6561eea8b6d9c0c25add906a6e83d733"
      }
    }
}
& {
  lib,
  drvs,
  "libsigc++2" | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://download.gnome.org/sources/libsigc++/2.12/libsigc++-2.12.1.tar.xz",
        sha256sum = "a9dbee323351d109b7aee074a9cb89ca3e7bcf8ad8edef1851f4cf359bd50843"
      }
    }
}
