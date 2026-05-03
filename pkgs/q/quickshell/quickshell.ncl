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
          "$(pkg-config --libs --static xrender)",
          "-lQt6MultimediaQuick",
          "/usr/lib/qt6/qml/QtMultimedia/libquickmultimediaplugin.a",
          "-Wl,--error-limit=0",
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
        @ (
          if options.vulkan then
            [
              "$(pkg-config --libs --static libpipewire-0.3)",
              "/tmp/workdir/src/dlopen.o",
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
      vulkan | default = false,
    },
    cmakeExtraArgsRecord = {
      # "-DINSTALL_QML_PREFIX" = "/lib/qt6/qml",
      "-DINSTALL_QML_PREFIX" = "/usr/lib/qt6/qml",

      "-DCMAKE_MODULE_LINKER_FLAGS:STRING" | priority 1 = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -ldrm $(pkg-config --libs --static dri glesv2 gbm egl wayland-client glib-2.0 gmodule-2.0 expat)\"",

      "-DCRASH_REPORTER" = options.crash,
      "-DCRASH_HANDLER" = options.crash,
      "-DX11" = options.x11,
      "-DSERVICE_PAM" = distro.pam,
      "-DSCREENCOPY" = options.vulkan,
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
        if options.vulkan then
          [
            drvs.vulkanHeaders,
          ]
        else
          []
      )
      @ (
        if options.x11 then
          [
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
          @ (
            if options.vulkan then
              [
                drvs.qtbaseVulkan,
              ]
            else
              [
                drvs.qtbaseX11,
              ]
          )
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
            # drvs.breakpad,
            drvs.cpptrace,
            drvs.libdwarf,
          ]
        else
          []
      ),
    allowDubplicateBuldInputs = true,
    pDrvs = [
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
      patches | priority 1 = [],
      eofPatches = [
        # {
        #   patch = import "fix-quickshell.patch" as 'Text,
        # },
        {
          patch = import "quickshell-no-wayland-dlsym.patch" as 'Text,
        },
      ],
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/dlopen.c" (import "quickshell_dlopen.c" as 'Text),
        lib.functions.writeFile "${SRC}/src/gen.cpp" (import "gen.cpp" as 'Text),
        "sed -i 's|quickshell main.cpp|quickshell main.cpp gen.cpp|g' ${SRC}/src/CMakeLists.txt",
        "cat >>${SRC}/CMakeLists.txt << 'EOF'\n%{import "link.cmake" as 'Text}\nEOF\n",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      ],
      debug = true,
      muslProvider = drvs.muslBothRenamedDl,
      options = {
        polkit = true,
        x11 = true,
        crash = (true),
        vulkan = true,
      },

      biDrvs | priority 1 = [
        drvs.cpptrace,
        drvs.libdwarf,
        drvs.polkit,
        drvs.jemalloc,
        # drvs.qtmultimedia,
      ],

      pDrvs | priority 1 = [
        drvs.qtmultimedia,
        drvs.qt5compat,
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
        drvs.pulseaudio17,
        drvs.cli11,
        drvs.zstd,
      ],

      singleSource | priority 1 = {
        uri = "https://github.com/quickshell-mirror/quickshell/archive/8db8ca1fecfcce8def1f9265fa1742baa0e0c271.tar.gz",
        sha256sum = "80d68bd65d247a0818c8b6544a341c5d04be8d11bff4f1e6a9f00c0f828c290a",

        # latest without vulkan:
        # uri = "https://github.com/quickshell-mirror/quickshell/archive/158db16b931d04b43ec84748ee49390ea9f7c3f8.tar.gz",
        # sha256sum = "dac6768b33e51d2930061ed789d603dd5eea0dd0a6255800b9b96afe517b4fa5",
      },
    }
}
