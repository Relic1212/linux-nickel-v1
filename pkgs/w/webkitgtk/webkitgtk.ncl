{
  lib,
  drvs,
  webkitgtk | lib.CmakePackage = {
    allowDubplicateBuldInputs = true,

    # debug = true,
    generator = "Ninja",
    singleSource = {
      # uri = "https://webkitgtk.org/releases/webkitgtk-2.53.2.tar.xz",
      # sha256sum = "79f03692f65149685c32c64c66c6f4696c91e652a2abfab0614532da323b8bb9",

      # uri = "https://webkitgtk.org/releases/webkitgtk-2.48.7.tar.xz",
      # sha256sum = "2c62aebb608e09f930a539f3623a5cc8023b5068029f42a208f45f9124da6e30",

      # uri = "https://webkitgtk.org/releases/webkitgtk-2.49.90.tar.xz",
      # sha256sum = "41abbda9cd7bc7aacf67479814b2bcb0188c7a4c5c86935f950f4a87c1a1641b",

      # uri = "https://webkitgtk.org/releases/webkitgtk-2.51.93.tar.xz",
      # sha256sum = "8a55ecc72e4e44c094a5109284a8adf69c2ff2c3bf8d9d46f9eb92a1aefa1408",

      uri = "https://webkitgtk.org/releases/webkitgtk-2.54.1.tar.xz",
      sha256sum = "ea0bbb02dbdbc596874a4e7ad35b66645b3e0a232bd0e4081de5ed92eb0a397d",
    },
    # eofPatches = [
    #   {
    #     patch = import "kilo-webkitgtk.patch" as 'Text,
    #   },
    # ],
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
        "$(pkg-config --libs --static libpcre2-8 libnghttp2 gmodule-2.0 gobject-2.0 libjxl libwebp libhwy libsoup-3.0 gnutls libproxy-1.0)",
        "$(pkg-config --libs --static gstreamer-full-1.0)",
        # "$(pkg-config --libs --static gstreamer-hip-1.0)",
        #  "$(pkg-config --libs --static gstreamer-hip-1.0)",
        # "/tmp/workdir/src/dlopen.o",
        "/usr/lib/gio/modules/libgiognomeproxy-static.a",
        "/usr/lib/gio/modules/libgiognutls-static.a",
        "/usr/lib/gio/modules/libgiolibproxy-static.a",
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
      "-DUSE_SYSTEM_SYSPROF_CAPTURE" = (!false),
      "-DUSE_SYSTEM_MALLOC_DEFAULT" = true,
      "-DENABLE_STATIC_JSC" = true,
      # "-DUSE_XDGMIME" = false, #  symbol collisions
      "-DUSE_THIN_ARCHIVES" = false,
      "-DUSE_GBM" = (!false),
      "-DUSE_ANGLE" = false,
      "-DENABLE_MINIBROWSER" = false,
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
      lib.functions.writeFile "${SRC}/dlopen.c" (import "webkitgtk_dlopen.c" as 'Text),
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      m%"sed -i "s@path.dump(&wStream, dumpAsHex);@@g" ${SRC}/Source/ThirdParty/skia/src/pathops/SkPathOpsDebug.cpp"%,
    ],

    postInstallPhase =
      [
        "install -m0755 lib/lib*.a ${DEST}/usr/lib/webkitgtk-6.0/",
        # "llvm-objcopy --redefine-sym=%{s}=libjxl__%{s} ${DEST}/usr/lib/webkitgtk-6.0/libxdgmime.a"
      ]
      @ (
        std.array.map
          (fun s => "llvm-objcopy --redefine-sym=%{s}=webkitgtk_libGLESv2_%{s} ${DEST}/usr/lib/webkitgtk-6.0/libGLESv2.a")
          (std.string.split "\n" (import "symbols.txt"))
      ),

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothWeakDl,
    # muslProvider = drvs.muslBothRenamedDl,

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
      drvs.gnupatch & { priority = 1 },
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
      # drvs.libtasn1,
      drvs.harfbuzzIcu,
      drvs.libwebp,
      drvs.libsecret,
      drvs.libjxl,
      drvs.libavif,
      drvs.lcms,
      drvs.libseccomp,
      drvs.gstreamer,
      drvs.glibNetworking,
      drvs.sysprof,
    ]
  },
  webkitgtkFinal | lib.CmakePackage =
    webkitgtk
    & {

      buildEnv = {
        EXTRA_LDFLAGS | priority 1 =
          webkitgtk.buildEnv.EXTRA_LDFLAGS
          @ [
            "-Wl,--start-group",
            "/tmp/workdir/src/dlopen.o",
            "-lwebkitgtk-missing-symbols",
            "/usr/lib/webkitgtk-6.0/injected-bundle/libwebkitgtkinjectedbundle.a",
            "/usr/lib/gio/modules/libgiognomeproxy-static.a",
            "/usr/lib/gio/modules/libgiognutls-static.a",
            "/usr/lib/gio/modules/libgiolibproxy-static.a",
            "/usr/lib/libwebpdemux.a",
            "$(pkg-config --libs --static lcms2 libseccomp libsecret-1 libavif icu-i18n harfbuzz-icu libxml-2.0 libwebpmux libwebpdemux sysprof-capture-4)",
            "/usr/lib/libGLESv2.a",
            "-L/usr/lib/webkitgtk-6.0/",
            "$(pkg-config --libs --static webkitgtk-6.0 webkitgtk-web-process-extension-6.0 javascriptcoregtk-6.0)",
            # "/usr/lib/webkitgtk-6.0/libWebKitWebProcess.a",
            # "-lANGLE",
            # "/usr/lib/webkitgtk-6.0/libGLESv2.a",
            # "-lWTFGTK",
            # "-lbmalloc",
            # "-lSysProfCapture",
            # "-lWebCore",
            # "-lSkia",
            # "-lxdgmime",
            # "-lPAL",
            # "/usr/lib/webkitgtk-6.0/libWebCoreDOMAndRendering.a",
            # "/usr/lib/webkitgtk-6.0/libWebCoreStyle.a",
          ]
          @ (
            std.array.map
              (fun s => "/usr/lib/webkitgtk-6.0/%{s}")
              [
                # "injected-bundle",
                "libANGLE.a",
                "libGLESv2.a",
                "libJavaScriptCoreJIT.a",
                "libLowLevelInterpreterLib.a",
                "libPAL.a",
                "libSkia.a",
                # "libSysProfCapture.a",
                "libWTFGTK.a",
                "libWebCore.a",
                "libWebCoreDOMAndRendering.a",
                "libWebCoreInspector.a",
                "libWebCoreJSBindings.a",
                "libWebCoreStyle.a",
                "libWebKitGPUProcess.a",
                "libWebKitNetworkProcess.a",
                "libWebKitShared.a",
                "libWebKitUIProcess.a",
                "libWebKitWebProcess.a",
                "libbmalloc.a",
                "libjavascriptcoregtk-6.0.a",
                "libwebkitgtk-6.0.a",
                "libwebkitgtkinjectedbundle.a",
                "libxdgmime.a",
                "injected-bundle/libwebkitgtkinjectedbundle.a"
              ]
          )
          @ [
            "-Wl,--end-group",
          ],
      },

      muslProvider | priority 1 = drvs.muslBothRenamedDl,
      biDrvs | priority 1 =
        webkitgtk.biDrvs
        @ [
          drvs.webkitgtk,
          drvs.webkitgtkMissingSyms,
        ],
    },

  webkitgtkMissingSyms | lib.Package = {
    buildPhase = [
      lib.functions.writeFile "${SRC}/missing_syms.c" (import "webkitgtk_missing_syms.c" as 'Text),
      "${CC} ${CFLAGS} -Werror -c -o ${SRC}/missing_syms.o ${SRC}/missing_syms.c",
      "${AR} rcs ${SRC}/libwebkitgtk-missing-symbols.a ${SRC}/missing_syms.o",
      "ranlib ${SRC}/libwebkitgtk-missing-symbols.a",
    ],

    installPhase = [
      "install -Dm0755 ${SRC}/libwebkitgtk-missing-symbols.a  ${DEST}/usr/lib/libwebkitgtk-missing-symbols.a",
    ],

    biDrvs = [
      drvs.llvm,
      drvs.musl,
    ],
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
