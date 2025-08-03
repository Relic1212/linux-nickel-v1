{
  lib,
  drvs,
  libxkbcommon | lib.MesonPackage = {
    name = "libxkbcommon",

    singleSource = {
      uri = "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.10.0.tar.gz",
      sha256sum = "0427585a4d6ca17c9fc1ac4b539bf303348e9080af70c5ea402503bc370a9631"
    },
    extraMesonArgs = ["-Denable-x11=false", "-Denable-xkbregistry=false"],
    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.bison,
      drvs.m4
    ]
  }
}
& {
  lib,
  drvs,
  libxkbcommon,
  libxkbcommonWithRegistry | lib.MesonPackage = {

    singleSource = libxkbcommon.singleSource,
    extraMesonArgs = ["-Denable-x11=false", "-Denable-xkbregistry=true"],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.bison,
      drvs.m4,
      drvs.libxml2,
    ]
  }
}
