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
    # symlinkBuldInputs = true,

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
    options = {
      x11 | default = false,
      crash | default = false,
      polkit | default = false,
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
        # sha256sum = "d973b39e5dbb76067839362df5a7159857279017f3d061d8bc3f357fec3bfdf3",
        # file = "fix-quickshell2.patch",

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
          ]
        else
          [
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
        # uri = "https://github.com/quickshell-mirror/quickshell/archive/e9a574d919a89602d2868621576b2ccae54a5cb0.tar.gz",
        # sha256sum = "637efbe5f117953c689caed88ae23dde9bc9bc480dc4063b3770903114b8c3ed",

        # uri = "https://github.com/quickshell-mirror/quickshell/archive/3e2ce40b18af943f9ba370ed73565e9f487663ef.tar.gz",
        # sha256sum = "cfcea1449650f4502a20a4a1a2ab973eebdc04203121f9c5674179b531824bee",    
        # uri = "https://github.com/quickshell-mirror/quickshell/archive/fc704e6b5d445899a1565955268c91942a4f263f.tar.gz",
        # sha256sum = "48b5ac6c321ea867fc5279478185e49292137b52d9fa3a2e93a07fabe353bee1",

        uri = "https://github.com/quickshell-mirror/quickshell/archive/ed036d514b0fdbce03158a0b331305be166f4555.tar.gz",
        sha256sum = "de7acc2e26e555f4bc52d19f06920b78abb7a0f2b7bb92dfcecf5bb0ae88bad4",
      },
    }
}
