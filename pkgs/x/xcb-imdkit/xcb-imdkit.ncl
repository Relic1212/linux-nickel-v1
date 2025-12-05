{
  lib,
  drvs,
  xcbImdkit | lib.CmakePackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/fcitx/xcb-imdkit/archive/refs/tags/1.0.9.tar.gz",
      sha256sum = "c2f0bbad8a335a64cdc7c19ac7b6ea1f0887dd6300ca9a4fa2e2fec6b9d3f695"
    },
    preConfigurePhase = [
      m%"sed -i 's@SHARED@STATIC@g' ${SRC}/src/CMakeLists.txt"%,
      m%"sed -i 's@add_subdirectory(test)@@g' ${SRC}/CMakeLists.txt"%,
    ],
    biDrvs = [
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
      drvs.xcbUtilKeysyms,
      drvs.xcbUtil,
      drvs.ecm,
    ]
  }
}
& {
  lib,
  drvs,
  xcbUtilKeysyms | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.1.tar.xz",
      sha256sum = "7c260a5294412aed429df1da2f8afd3bd07b7cba3fec772fba15a613a6d5c638"
    },
    biDrvs = [
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
      drvs.pkgconf,
    ]
  }
}
& {
  lib,
  drvs,
  xcbUtil | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-0.4.1.tar.xz",
      sha256sum = "5abe3bbbd8e54f0fa3ec945291b7e8fa8cfd3cccc43718f8758430f94126e512"
    },
    biDrvs = [
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
      drvs.pkgconf,
    ]
  }
}
& {
  lib,
  drvs,
  xcbUtilImage | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xcb.freedesktop.org/dist/xcb-util-image-0.4.1.tar.xz",
      sha256sum = "ccad8ee5dadb1271fd4727ad14d9bd77a64e505608766c4e98267d9aede40d3d"
    },
    biDrvs = [
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
      drvs.pkgconf,
      drvs.xcbUtil,
    ]
  }
}
