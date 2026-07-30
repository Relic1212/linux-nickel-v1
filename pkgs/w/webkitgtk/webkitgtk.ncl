{
  lib,
  drvs,
  webkitgtk | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://webkitgtk.org/releases/webkitgtk-2.53.2.tar.xz",
      # sha256sum = "79f03692f65149685c32c64c66c6f4696c91e652a2abfab0614532da323b8bb9",

      # uri = "https://webkitgtk.org/releases/webkitgtk-2.48.7.tar.xz",
      # sha256sum = "2c62aebb608e09f930a539f3623a5cc8023b5068029f42a208f45f9124da6e30",

      # uri = "https://webkitgtk.org/releases/webkitgtk-2.49.90.tar.xz",
      # sha256sum = "41abbda9cd7bc7aacf67479814b2bcb0188c7a4c5c86935f950f4a87c1a1641b",

      uri = "https://webkitgtk.org/releases/webkitgtk-2.51.93.tar.xz",
      sha256sum = "8a55ecc72e4e44c094a5109284a8adf69c2ff2c3bf8d9d46f9eb92a1aefa1408",
    },
    unpackPhase = [
      "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/%{std.string.split "/" singleSource.uri |>std.array.last } -C /tmp/workdir/src --strip-components=1",
    ],
    buildEnv = {
      EXTRA_CXXFLAGS = [
        "-mcx16",
      ],
      EXTRA_CFLAGS = EXTRA_CXXFLAGS,
      EXTRA_LDFLAGS = [
        "-Wl,--allow-multiple-definition",
        "$(pkg-config --libs --static libpcre2-8 libnghttp2 gmodule-2.0 gobject-2.0 libjxl libwebp libhwy libsoup-3.0)",
        "$(pkg-config --libs --static gstreamer-full-1.0)",
        # "$(pkg-config --libs --static gstreamer-hip-1.0)",
        #  "$(pkg-config --libs --static gstreamer-hip-1.0)",
        "-Wl,--error-limit=0",
      ],
    },
    cmakeExtraArgsRecord = {
      "-DPORT" = "GTK",
      "-DENABLE_GAMEPAD" = false,
      "-DENABLE_DOCUMENTATION" = false,
      "-DENABLE_INTROSPECTION" = false,
      "-DENABLE_JOURNALD_LOG" = false,
      "-DENABLE_X11_TARGET" = false,
      "-DUSE_LIBHYPHEN" = false,
      "-DENABLE_XSLT" = false,
      "-DENABLE_QUARTZ" = false,
      "-DUSE_FLITE" = false,
      "-DENABLE_SPEECH_SYNTHESIS" = false,
      "-DENABLE_SPELLCHECK" = false,
      "-DUSE_WOFF2" = false,
      "-DUSE_LIBBACKTRACE" = false,
      "-DUSE_GSTREAMER" = true,
      # "-DUSE_GSTREAMER_GL" = false,
      "-DUSE_GSTREAMER_FULL" = true,
      # "-DUSE_GSTREAMER_WEBRTC" = false,
      # "-DUSE_GSTREAMER_MPEGTS" = false,
      "-DENABLE_WEB_AUDIO" = false,
      "-DUSE_SYSTEM_SYSPROF_CAPTURE" = false,
      "-DUSE_SYSTEM_MALLOC_DEFAULT" = true,
      "-DENABLE_STATIC_JSC" = true,
      # "-DUSE_XDGMIME" = false, #  symbol collisions
    },

    preEnvSetupPhase = [
      m%"export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig""%,
      #  "export PKG_CONFIG_PATH=\"/usr/lib/gstreamer-1.0/pkgconfig:/usr/lib/pkgconfig\"",
    ],

    preConfigurePhase = [
      "sed -i 's|SHARED|STATIC|g' ${SRC}/Source/cmake/OptionsGTK.cmake",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/Source/cmake/WebKitCommon.cmake",
      "sed -i 's| MODULE | STATIC |g' ${SRC}/Source/WebKit/PlatformGTK.cmake",
      "sed -i 's| MODULE | STATIC |g' ${SRC}/Tools/TestWebKitAPI/glib/CMakeLists.txt",
      "sed -i 's| MODULE | STATIC |g' ${SRC}/Tools/TestWebKitAPI/glib/WPEPlatform/CMakeLists.txt",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Source/WebKit/WPEPlatform/CMakeLists.txt",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Tools/CMakeLists.txt",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Source/cmake/OptionsJSCOnly.cmake",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Source/cmake/WebKitMacros.cmake",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Source/cmake/OptionsGTK.cmake",
      "sed -i 's| OBJECT| STATIC|g' ${SRC}/Source/JavaScriptCore/CMakeLists.txt",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.perl,
      drvs.pythonFull,
      drvs.ruby,
      # drvs.pkgconfMeson,
      drvs.bubblewrap,
      drvs.xdgDbusProxy,
      drvs.gperf,
      drvs.unidef,
      drvs.gettext,
      drvs.libjpegTurboStatic,
      drvs.libelfFixed,
      drvs.glibFixed,
    ],
    neverInclude = [
      drvs.harfbuzz,
      drvs.harfbuzzFull,
      drvs.libjpegTurbo,
      drvs.libelf,
      drvs.glib,
    ],
    pDrvs = [
      drvs.gtk4,
      # drvs.libgcrypt,
      drvs.libsoup3,
      drvs.libtasn1,
      drvs.harfbuzzIcu,
      drvs.libwebp,
      drvs.libsecret,
      drvs.libjxl,
      drvs.libavif,
      drvs.lcms,
      drvs.libseccomp,
      drvs.gstreamer,
    ]
  },
  libelf,
  libelfFixed =
    libelf
    & {
      postInstallPhase | priority 1 =
        libelf.postInstallPhase
        @ [
          "llvm-objcopy --redefine-sym=crc32=libelf__crc32 ${DEST}/usr/lib/libeu.a",
        ]
    },
  glib,
  glibFixed =
    glib
    & {
      postInstallPhase | priority 1 =
        glib.postInstallPhase
        @ [
          "llvm-objcopy --redefine-sym=_caches=_glib___caches ${DEST}/usr/lib/libgio-2.0.a",
          "llvm-objcopy --redefine-sym=_xdg_binary_or_text_fallback=_glib___xdg_binary_or_text_fallback ${DEST}/usr/lib/libgio-2.0.a",
        ]
    }
}
