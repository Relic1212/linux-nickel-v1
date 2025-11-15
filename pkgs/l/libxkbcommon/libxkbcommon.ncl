{
  lib,
  drvs,
  libxkbcommon | lib.MesonPackage = {
    name = "libxkbcommon",

    singleSource = {
      # uri = "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.10.0.tar.gz",
      # sha256sum = "0427585a4d6ca17c9fc1ac4b539bf303348e9080af70c5ea402503bc370a9631",

      uri = "https://github.com/xkbcommon/libxkbcommon/archive/refs/tags/xkbcommon-1.13.0.tar.gz",
      sha256sum = "cd9367eec501867dfe7ddc3f6b18a026f2a2844a89d19108448d376cb849c9ed",
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
& {
  lib,
  drvs,
  libxkbcommon,
  libxkbcommonX11 | lib.MesonPackage = {

    singleSource = libxkbcommon.singleSource,
    extraMesonArgs = ["-Denable-x11=true", "-Denable-xkbregistry=true"],

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
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.zlibNg,
      drvs.xcbRenderutil,
      drvs.xcbUtilWm,
    ]
  }
}
