{
  lib,
  pkgs,
  libinput | lib.MesonPackage
    = {
      name = "libinput",
      singleSource = {
        uri = "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.26.2/libinput-1.26.2.tar.gz",
        sha256sum = "5c1c4150f217fea1db2d1fd88e2607b2f1928cfde65c34da65a9f24dcfd69464",
      },
      preConfigurePhase = [
        m%"sed -i "s/shared_library/library/" ${SRC}/meson.build"%
      ],
      extraMesonArgs = ["-Dtests=false", "-Dlibwacom=false", "-Ddebug-gui=false"],
      biDrvs =
        lib.biMap [
          pkgs.eudev,
          # pkgs.libudevZero,
          pkgs.mtdev,
          pkgs.libevdev,
          pkgs.linuxHeaders,
        ]
    }
}
