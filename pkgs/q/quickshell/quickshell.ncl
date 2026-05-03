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
