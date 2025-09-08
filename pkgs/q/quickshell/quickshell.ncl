{
  lib,
  drvs,
  distro,
  quickshell | lib.QtPackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v0.2.0.tar.gz",
      sha256sum = "bd000d6ab5fbf050d3c6157af63f1ee7b35755a350ff8064b9b55b8a7f1682df",

      #uri = "https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v0.1.0.tar.gz",
      #sha256sum = "4f37cc5301443de4456550c4b16a517d5478a65ec1c8a37bd006db3832a1ab42",
    },

    llvmProvider = drvs.llvmFull,
    # symlinkBuldInputs = true,

    biDrvs = [
      drvs.pixman,
      drvs.expat,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.libjpegTurboStatic,
      drvs.libspng,
      drvs.file,
      drvs.libwebp,
      drvs.qtdeclarative,
      drvs.qtbase,
      drvs.qtshadertools,
      drvs.qtwayland,
      drvs.qtsvg,
      drvs.mesa2,
      # drvs.pkgconf,
      drvs.libelf,
      drvs.libdrm,
      drvs.pythonMako,
      drvs.pythonPackaging,
      drvs.pythonMarkupsafe,
      drvs.libpciaccess,
      drvs.bison,
      drvs.flex,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.m4,
      drvs.pyyaml,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      ###
      drvs.jsonC,
      drvs.pcre2,
      drvs.libxkbcommon,
      drvs.openssl,
      drvs.kmod,
      drvs.zstd,
      drvs.xz,
      drvs.eudev,
      drvs.libinput,

      # drvs.dbusForQt,
      drvs.dbus,
      drvs.cli11,
      drvs.qt5compat,

      ## X
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
      drvs.xcbRenderutil,
      drvs.libxfont2,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.xcbUtilWm,
      ## -X
      drvs.bluez,
      drvs.sbc,
      drvs.libusb,
      drvs.ffmpeg,
      drvs.jansson,
      # drvs.libfreeaptx,
      drvs.fdkAac,
      drvs.ldacbt,
      # drvs.libcamera,
      drvs.libyaml,
      drvs.libsndfile,
      drvs.libopus,
      drvs.lua,
      drvs.alsaLibs,
      drvs.jemalloc,
    ],
    allowDubplicateBuldInputs = true,
    propagatedBuildInputs = [
      drvs.pipewire,
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat) -pthread",
      ]
    },
    cmakeExtraArgsRecord = {
      # "-DINSTALL_QML_PREFIX" = "/lib/qt6/qml",
      "-DINSTALL_QML_PREFIX" = "/usr/lib/qt6/qml",

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",

      "-DCRASH_REPORTER" = false,
      "-DX11" = false,
      "-DSERVICE_PAM" = distro.pam,
      "-DSERVICE_MPRIS" = true,
      "-DSERVICE_PIPEWIRE" = true,
      "-DBLUETOOTH" = true,
      "-DUSE_JEMALLOC" = true,
      "-DNO_PCH" = true,
    },

    # preConfigurePhase = [

    #   m%"
    #   echo "
    #   qt_import_plugins(quickshell INCLUDE 
    #     Qt6::QWaylandIntegrationPlugin
    #     Qt6::QWaylandXdgShellIntegrationPlugin
    #     Qt6::QWaylandBradientDecorationPlugin
    #     Qt6::LabsPlatformplugin
    #     Qt6::qtquickdialogsplugin
    #     Qt6::labsmodelsplugin
    #   )
    #   " >> ${SRC}/src/CMakeLists.txt
    #   "%
    # ],
    patches = [
      {
        sha256sum = "d973b39e5dbb76067839362df5a7159857279017f3d061d8bc3f357fec3bfdf3",
        file = "fix-quickshell2.patch"
      }
    ]
  }
}
