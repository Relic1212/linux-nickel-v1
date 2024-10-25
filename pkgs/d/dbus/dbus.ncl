{
  lib,
  pkgs,
  dbus | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://dbus.freedesktop.org/releases/dbus/dbus-1.15.8.tar.xz",
        sha256sum = "1"
      }
    }
}
