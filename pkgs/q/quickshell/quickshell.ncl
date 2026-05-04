{
  lib,
  drvs,
  distro,
  quickshell | lib.QtPackage = {

    llvmProvider = drvs.llvmFull,

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

    allowDubplicateBuldInputs = true,

    eofPatches = [
      # {
      #   patch = import "fix-quickshell.patch" as 'Text,
      # },
      {
        patch = import "quickshell-no-wayland-dlsym.patch" as 'Text,
      },
    ],
    preConfigurePhase = [
      lib.functions.writeFile "${SRC}/dlopen.c" (import "quickshell_dlopen.c" as 'Text),
      lib.functions.writeFile "${SRC}/src/gen.cpp" (import "gen.cpp" as 'Text),
      "sed -i 's|quickshell main.cpp|quickshell main.cpp gen.cpp|g' ${SRC}/src/CMakeLists.txt",
      "cat >>${SRC}/CMakeLists.txt << 'EOF'\n%{import "link.cmake" as 'Text}\nEOF\n",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],
    muslProvider = drvs.muslBothRenamedDl,
    options = {
      polkit = true,
      x11 = true,
      crash = (true),
      vulkan = true,
    },

    biDrvs = [
      drvs.cpptrace,
      drvs.libdwarf,
      drvs.polkit,
      drvs.jemalloc,
      # drvs.qtmultimedia,
    ],

    pDrvs = [
      drvs.qtmultimedia,
      drvs.qt5compat,
      # drvs.bluez,
      # drvs.sbc,
      # drvs.libusb,
      # drvs.ffmpeg,
      # drvs.jansson,
      # drvs.libfreeaptx,
      # drvs.fdkAac,
      # drvs.ldacbt,
      # 
      # drvs.libyaml,
      # drvs.libsndfile,
      # drvs.libopus,
      # drvs.lua,
      # drvs.alsaLibs,
      drvs.pulseaudio17,
      drvs.cli11,
      drvs.zstd,
    ],

    singleSource = {
      uri = "https://github.com/quickshell-mirror/quickshell/archive/8db8ca1fecfcce8def1f9265fa1742baa0e0c271.tar.gz",
      sha256sum = "80d68bd65d247a0818c8b6544a341c5d04be8d11bff4f1e6a9f00c0f828c290a",

      # latest without vulkan:
      # uri = "https://github.com/quickshell-mirror/quickshell/archive/158db16b931d04b43ec84748ee49390ea9f7c3f8.tar.gz",
      # sha256sum = "dac6768b33e51d2930061ed789d603dd5eea0dd0a6255800b9b96afe517b4fa5",
    },
  },
  noctaliaQs | lib.QtPackage =
    quickshell
    & {
      singleSource | priority 1 = {
        uri = "https://github.com/noctalia-dev/noctalia-qs/archive/refs/tags/v0.0.12.tar.gz",
        sha256sum = "5de37541537307d141618aa0d782d3c34e42a6ad21c73533cce80c0e71ee9693",

        # uri = "https://github.com/noctalia-dev/noctalia-qs/archive/d3e26ccd9eecde9139be00caf5dc2d4260fb31ee.tar.gz",
        # sha256sum = "704154f67079393a193f45eef9b296b775bb8b8a329835e10e97236875c7a0e6"
      },
      # debug = true,

      muslProvider | priority 1 = drvs.muslBothRenamedDlRelease,
      llvmProvider | priority 1 = drvs.llvmFullTypeinfo,
      # neverInclude = [drvs.qtbaseVulkan],
      # biDrvs | priority 1 = quickshell.biDrvs @ [drvs.qtbaseDebug]
      # eofPatches | priority 1 =
      #   quickshell.eofPatches
      #   @ [
      #     {
      #       patch = import "quickshell-fix-xdg_popup.patch" as 'Text
      #     },
      #   ],
      # buildEnv.EXTRA_LDFLAGS | priority 1 =
      #   quickshell.buildEnv.EXTRA_LDFLAGS
      #   @ [
      #     "-lLayerShellQtQml",
      #   ],
      # preConfigurePhase | priority 1 = [
      #   lib.functions.writeFile "${SRC}/dlopen.c" (import "quickshell_dlopen.c" as 'Text),
      #   lib.functions.writeFile "${SRC}/src/gen.cpp" (import "noctalia_gen.cpp" as 'Text),
      #   "sed -i 's|quickshell main.cpp|quickshell main.cpp gen.cpp|g' ${SRC}/src/CMakeLists.txt",
      #   m%"sed -i "s@add_subdirectory(src)@%{
      #     m%"find_package(PkgConfig REQUIRED)\n"% ++
      #     m%"pkg_check_modules(XKBCOMMON REQUIRED IMPORTED_TARGET xkbcommon)\n"% ++
      #     m%"find_package(LayerShellQt REQUIRED)\n"%
      #   }add_subdirectory(src)@g" ${SRC}/CMakeLists.txt"%,
      #   "cat >>${SRC}/CMakeLists.txt << 'EOF'\n%{import "noctalia_link.cmake" as 'Text}\nEOF\n",
      #   "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      # ],

      # biDrvs | priority 1 =
      #   quickshell.biDrvs
      #   @ [
      #     drvs.layerShellQt,
      #   ],
    },

  llvmFull,
  qtbaseVulkan,
  qtbaseDebug | lib.QtPackage =
    qtbaseVulkan
    & {
      # debug = true,
            buildEnv._optFlag | priority 1 = "-O0",

      options.optlevel = "0",
      preConfigurePhase | priority 1 = [],
      cmakeExtraArgsRecord = {
        # "-DCMAKE_BUILD_TYPE" | priority 1 = "RelWithDebInfo",
        "-DCMAKE_BUILD_TYPE" | priority 1 = "Debug",
      },
    },
  llvmFullTypeinfo | lib.CmakePackage =
    llvmFull
    & {
      cmakeExtraArgsRecord = {
        "-DLIBCXX_TYPEINFO_COMPARISON_IMPLEMENTATION" = "2",
        # "-DLLVM_ENABLE_RTTI"|priority 1 = "ON",
      },
    }
}
