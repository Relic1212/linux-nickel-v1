{
  lib,
  drvs,
  libinput | lib.MesonPackage = {
    name = "libinput",
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.26.2/libinput-1.26.2.tar.gz",
      # sha256sum = "5c1c4150f217fea1db2d1fd88e2607b2f1928cfde65c34da65a9f24dcfd69464",
      uri = "https://gitlab.freedesktop.org/libinput/libinput/-/archive/1.29.0/libinput-1.29.0.tar.gz",
      sha256sum = "ec71f6ec6632108a62756f49d86e864494108e70cf670e85f8b7579e970e152c",
    },
    preConfigurePhase = [
      m%"sed -i "s/shared_library/library/" ${SRC}/meson.build"%
    ],
    extraMesonArgs = ["-Dtests=false", "-Dlibwacom=false", "-Ddebug-gui=false"],
    biDrvs = [
      drvs.eudev,
      # drvs.libudevZero,
      drvs.mtdev,
      drvs.libevdev,
      drvs.linuxHeaders,
    ]
  }
}
