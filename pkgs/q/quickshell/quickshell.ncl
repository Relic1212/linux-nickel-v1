{
  lib,
  drvs,
  distro,
  quickshell | lib.QtPackage = {
    generator = "Ninja",

    singleSource = {
      uri = "https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v0.2.1.tar.gz",
      sha256sum = "337bab5d4badb92e51d01ac1cfbeaeb784478bad82f3c8297fd7be42a6995af2",

      #uri = "https://github.com/quickshell-mirror/quickshell/archive/refs/tags/v0.1.0.tar.gz",
      #sha256sum = "4f37cc5301443de4456550c4b16a517d5478a65ec1c8a37bd006db3832a1ab42",
    },

    llvmProvider = drvs.llvmFull,
    # 

    buildEnv = {
      EXTRA_LDFLAGS =
        [
          "$(pkg-config --libs --static gbm glesv2 egl dri wayland-client glib-2.0 gmodule-2.0 expat) -pthread",
          "$(pkg-config --static --libs libavdevice)",
          "$(pkg-config --static --libs libpulse)",
          "-lQt6MultimediaQuick",
          "/usr/lib/qt6/qml/QtMultimedia/libquickmultimediaplugin.a",
        ]
        @ (
          if options.x11 then
            [
              # "$(pkg-config --static --libs libudev)",
              # "$(pkg-config --static --libs libevdev)",
              "$(pkg-config --static --libs xcb)",
              "$(pkg-config --static --libs xcb-shm)",
              "$(pkg-config --static --libs x11-xcb)",
              "$(pkg-config --static --libs xau)",
            ]
          else
            []
        )
    },
    preConfigurePhase = [
      m%"sed -i 's@#include <bits/types/sigset_t.h>@@g' ${SRC}/src/crash/handler.cpp"%,
      # m%"sed -i "s@qt_add_executable(quickshell main.cpp)@qt_add_executable(quickshell main.cpp)\nfind_package(Qt6WaylandScannerTools REQUIRED)@g" ${SRC}/src/CMakeLists.txt"%,
      m%"sed -i "s@set(QT_FPDEPS Gui Qml Quick QuickControls2 Widgets ShaderTools)@set(QT_FPDEPS Gui Qml Quick QuickControls2 Widgets ShaderTools WaylandScannerTools WaylandCompositor)@g" ${SRC}/CMakeLists.txt"%,
    ],
    options = {
      x11 | default = true,
      crash | default = true,
      polkit | default = true,
    },
    cmakeExtraArgsRecord = {
      # "-DINSTALL_QML_PREFIX" = "/lib/qt6/qml",
      "-DINSTALL_QML_PREFIX" = "/usr/lib/qt6/qml",

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",

      "-DCRASH_REPORTER" = options.crash,
      "-DX11" = options.x11,
      "-DSERVICE_PAM" = distro.pam,
      "-DSERVICE_MPRIS" = true,
      "-DSERVICE_PIPEWIRE" = true,
      "-DBLUETOOTH" = true,
      "-DUSE_JEMALLOC" = true,
      "-DNO_PCH" = true,
      "-DI3" = true,
      "-DI3_IPC" = true,
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

        sha256sum = "feb151bab65843bf172a0c0e838d9aa7ab385e477f7d8bdf008fe00c8e4de662",
        file = "fix-quickshell3.patch",
      }
    ],
    biDrvs =
      [
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
        # drvs.qtbase,
        drvs.qtshadertools,
        drvs.qtwayland,
        drvs.qtsvg,
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
        # drvs.xwayland,
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
        # 
        drvs.libyaml,
        drvs.libsndfile,
        drvs.libopus,
        drvs.lua,
        drvs.alsaLibs,
        drvs.jemalloc,
        drvs.qtmultimedia,
        drvs.pulseaudio17,
      ]
      @ (
        if options.x11 then
          [
            drvs.qtbaseX11,
            drvs.libxkbcommonX11,
            drvs.xcbUtil,
            drvs.xcbUtilCursor,
            drvs.xcbUtilErrors,
            drvs.xcbUtilImage,
            drvs.xcbUtilKeysyms,
            drvs.mesa2,
            # drvs.mesaGlx,
            # drvs.libxext,
            # drvs.libxf86vm,
            # drvs.libxrandr,
          ]
        else
          [
            drvs.mesa2,
            drvs.libxkbcommon,
            drvs.qtbase,
          ]
      )
      @ (
        if options.polkit then
          [
            drvs.polkit,
          ]
        else
          []
      )
      @ (
        if options.crash then
          [
            drvs.breakpad,
          ]
        else
          []
      ),
    allowDubplicateBuldInputs = true,
    propagatedBuildInputs = [
      drvs.pipewire,
    ],
  }
}
& {
  lib,
  drvs,
  quickshell,
  quickshellGit =
    quickshell
    & {
      options = {
        polkit = true,
        x11 = true,
        # crash =true,
      },
      singleSource | priority 1 = {
        uri = "https://github.com/quickshell-mirror/quickshell/archive/191085a8821b35680bba16ce5411fc9dbe912237.tar.gz",
        sha256sum = "869fc88b6f2098bf5660fc46a9f9ca9e2b7a10bf182bf5ab57c0b14560813e8d",
      },
    }
}
