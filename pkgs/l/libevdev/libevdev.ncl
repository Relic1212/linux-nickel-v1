{
  lib,
  linuxHeaders,

  libevdev | lib.MesonPackage = {
    name = "libevdev",
    singleSource = {
      uri = "https://gitlab.freedesktop.org/libevdev/libevdev/-/archive/libevdev-1.13.3/libevdev-libevdev-1.13.3.tar.gz",
      sha256sum = "39e431563f0b35e4794b3af3f61bc05f81ef5d25f10238af9768ddf4589abef7"
    },
    extraMesonArgs = ["-Ddocumentation=disabled", "-Dtests=disabled"],
    biDrvs =
      lib.biMap [
        linuxHeaders,
      ]
  }
}
