{
  drvs,
  lib = {
    QtPackage,
    LxqtPackage =
      QtPackage
      & {
        utilsProviders,
        pkgconfProvider,
        muslProvider,
        isLlvm,
        llvmProviders,
        enableCcache,
        generator,
        libxkbcommonProvider | default = drvs.libxkbcommon,
        llvmProvider | priority -1000 = drvs.llvmFull,
        baseBuildinputPackages | priority -999 =
          utilsProviders
          @ (
            [
              drvs.cmake,
              # drvs.pkgconf,
              pkgconfProvider,
              muslProvider,
            ]
            @ (if isLlvm then llvmProviders else [])
            @ (if enableCcache then [drvs.ccacheBin] else [])
            @ (if (generator == "Ninja") then [drvs.samurai] else [])
          )
          @ [
            drvs.cairo,
            drvs.dbusForQt,
            drvs.eudev,
            drvs.expat,
            drvs.fontconfig,
            drvs.freetype,
            drvs.glib,
            drvs.harfbuzzFull,
            drvs.jsonC,
            drvs.kmod,
            drvs.libdrm,
            drvs.libelf,
            drvs.libffi,
            drvs.libinput,
            drvs.libpciaccess,
            drvs.libpng,
            libxkbcommonProvider,
            drvs.linuxHeaders,
            drvs.llvmConfigStatic,
            drvs.mesa2,
            drvs.openssl,
            drvs.pcre2,
            drvs.pixman,
            drvs.spirvLlvmTranslator,
            drvs.spirvTools,
            drvs.utilLinux,
            drvs.wayland,
            drvs.waylandProtocols,
            drvs.zlibNg,
            drvs.qtbase,
            drvs.qtwayland,
            drvs.qtTools,
            drvs.qtdeclarative,
            drvs.qtshadertools,
            drvs.qt5compat,
            drvs.qtsvg,
          ],
      }
  },
}
& {
  lib,
  drvs,
  liblxqt | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/liblxqt/archive/refs/tags/2.3.0.tar.gz",
      sha256sum = "c59987b2c4388bf41226847261c168a6cb34637f881ed66a425440fea0769091",
    },
    patches = [
      {
        sha256sum = "3097453c5a4eee604b037ebc67275671a371e53b9472b9e416fe76fb22bf0f8a",
        file = "liblxqt-nox11.patch",
      },
    ],
    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "-Wl,--allow-multiple-definition",
    #   ],
    # },
    preConfigurePhase = [
      m%"sed -i 's|SHARED|STATIC|g' ${SRC}/CMakeLists.txt"%,
    ],
    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.kwindowsystem,
      drvs.libcap,
      drvs.libpamFinalUdev,
      drvs.libqtxdg,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxext,
      drvs.libxfixes,
      drvs.libxrender,
      drvs.libxss,
      drvs.lxqtBuildTools,
      drvs.plasmaWaylandProtocols,
      drvs.polkit,
      drvs.polkitQt6,
      drvs.xcbProto,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
    ],
  },
  lxqtBuildTools | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/lxqt-build-tools/archive/refs/tags/2.3.0.tar.gz",
      sha256sum = "ec4e890d3bfa4c249179d5eb70e5e2f9adc73f6a86e5f79be0c7c1ca0661a593"
    }
  }
}
