{
  lib,
  drvs,
  # firefoxJumbo | lib.Package =
  #   firefox
  #   & {
  #     options.jumbo = true,
  #   },
  _firefoxDebug | lib.Package =
    firefox
    & {
      debug = true,
    },

  firefox | lib.Package = {
    # debug = true,
    debug,
    options = {
      jumbo | default = true,
      link | default = [
        "-Wl,--start-group",
        "/usr/lib/libgcm.a",
        "/usr/lib/libhw-acc-crypto-avx2.a",
        "/usr/lib/libhw-acc-crypto-avx.a",
        "/usr/lib/libghash-aes-x86_c_lib.a",
        "/usr/lib/libsha-x86_c_lib.a",
        "/usr/lib/libintel-gcm-wrap_c_lib.a",
        "/usr/lib/libfreebl_static.a",
        "/usr/lib/libpk11wrap.a",
        "/usr/lib/libnssutil.a",
        # "/usr/lib/libEGL.a",
        "/usr/lib/libplds4.a",
        "/usr/lib/libplc4.a",
        "/usr/lib/libsoftokn.a",
        "/usr/lib/libfreeblpriv3.a",
        "/usr/lib/libnss_static.a",
        "/usr/lib/libnssckbi.a",
        "/usr/lib/libnssckfw.a",
        "/usr/lib/libnssb.a",
        "/usr/lib/libcertdb.a",
        "/usr/lib/libcerthi.a",
        "/usr/lib/libcryptohi.a",
        "/usr/lib/libnssdev.a",
        "/usr/lib/libnsspki.a",
        "/usr/lib/libpkcs12.a",
        "/usr/lib/libpkcs7.a",
        "/usr/lib/libsmime.a",
        "/usr/lib/libssl_nss.a",
        "/usr/lib/libsharpyuv.a",
        #
        # "/usr/lib/libnspr4.a",
        # "/usr/lib/libsqlite3.a",
        # "/usr/lib/libpqcwrap.a",
        "/usr/lib/libpqcwrap_static.a",
        "/usr/lib/libcrux.a",
        # "/usr/lib/libfreebl.a",
        "-Wl,--end-group",
      ]
    },

    singleSource = {
      uri = "https://archive.mozilla.org/pub/firefox/releases/153.7.0esr/source/firefox-153.7.0esr.source.tar.xz",
      sha256sum = "7f8715ee7de2cf36a156216a9b1c7f26d1653010e65793bb2fce66e12edb6ea0",
    },
    separateBuildDir = false,
    unpackPhase = [
      "time tar xf /tmp/workdir/packed/*/firefox-*esr.source.tar.xz -C /tmp/workdir/src --strip-components=1",
    ],

    remotePatches = [
      {
        src = {
          uri = "https://raw.githubusercontent.com/git-bruh/kiss-repo/fb84873f60c64bf0b6080db69772b5731c683eeb/overrides/firefox/patches/bindgen-llvm.patch",
          sha256sum = "9e14a0a7d892fa38a7c82a8e1d4088a72da910a41bc9f739e746beee9f48d06f",
        },
      },
    ],

    eofPatches = [
      {
        # revert https://github.com/signalapp/webrtc/commit/a0253ec15b3d3072fb35d6be29ba9224c36f9dd7
        patch = import "../../c/chromium/chromium157-webrtc-pw-1.4.patch" as 'Text,
        subdir = "/third_party/libwebrtc",
      },
    ],
    buildEnv = {
      PKG_CONFIG = null,
      EXTRA_CPPFLAGS = [
        "-D_LIBCPP_DISABLE_VISIBILITY_ANNOTATIONS",
      ],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
      EXTRA_CXXFLAGS = EXTRA_CPPFLAGS,
      AS = "clang",
      EXTRA_LDFLAGS =
        [
          "$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
          "$(pkg-config --static --libs gtk+-3.0 libcap libpci libavcodec)",
          # "$(pkg-config --static --libs nss)",
          "-Wl,--error-limit=0",
          "-Wl,--verbose",
          "-Wl,-Map=firefox.map",
          # "-Wl,--allow-multiple-definition",
          # "/tmp/workdir/src/libdlopen.a",
        ]
        @ (options.link),
    },

    preConfigurePhase =
      ["mkdir dl-json", ]
      @ (std.array.map_with_index (fun a l => lib.functions.writeFile "dl-json/%{a}.json" (std.serialize 'Json l)) ((import "_dl.ncl") |> std.record.values))
      @ [
        "dl-func %{std.array.map_with_index (fun a l=>"--file=dl-json/%{a}.json") ((import "_dl.ncl")|>std.record.values)|>std.string.join " "} > ${SRC}/dlopen.c",
        lib.functions.writeFile "dlopen_bl.c" (import "load.c" as 'Text),
        "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        "${CC} ${CFLAGS} -c ${SRC}/dlopen_bl.c -o ${SRC}/dlopen_bl.o",
        "${AR} rcs libdlopen.a dlopen.o dlopen_bl.o",
        "export HOME=${BUILDDIR}/home",
        "mkdir -p $HOME",
        "export PIP_NO_INDEX=1",
        "export MACH_NO_WRITE_TIMES=1", # https://firefox-source-docs.mozilla.org/build/buildsystem/environment-variables.html
        "export MOZ_BUILD_DATE=${SOURCE_DATE_EPOCH}",
        "sed -i 's|when=link_libstdcxx_statically|when=target_is_windows|g' ${SRC}/build/moz.configure/flags.configure",
        (
          let rustflags =
            [
              "-C target-feature=+crt-static",
              # "-C link-self-contained=yes",
              "-C link-self-contained=no",
              "-C link-arg=-static",
              "-C link-arg=--static",
              # "-C link-arg=/tmp/workdir/src/libdlopen.a",
            ]
            @ (
              std.array.map
                (fun s => "-C link-arg=%{s}")
              # options.link
                []
            )
          in
          m%"CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS="%{std.string.join " " rustflags}""%
          # m%"RUSTFLAGS="%{std.string.join " " rustflags}""%
        ),
        # "export RUSTFLAGS",
        "export CARGO_HOST_RUSTFLAGS=\"-C target-feature=-crt-static\"",
        "export CARGO_TARGET_X86_64_UNKNOWN_LINUX_MUSL_RUSTFLAGS",
        "export SCCACHE_DIR=/tmp/sccache/",
        "export SCCACHE_CACHE_SIZE=100G",
        "export SCCACHE_SERVER_UDS=/tmp/sccache.sock",
        "export RUSTC_WRAPPER=/usr/bin/sccache",
        "export SCCACHE_START_SERVER=0",
        "export SCCACHE_NO_DAEMON=1",
        "mkdir -p ${HOME}/.config/sccache/",
        "touch ${HOME}/.config/sccache/config",
        # "sccache --stop-server || echo 'sccache server not running'",
        "sccache --start-server",
        "echo sccache setup done",
        "export MACH_BUILD_PYTHON_NATIVE_PACKAGE_SOURCE=\"system\"",
        "echo 'patching with python'",
        "python << 'EOF'\n%{import "patch.py" as 'Text}\n\nEOF\n",
        "echo 'done patching with python'",
        m%"sed -i 's@"runtime"@"static","libcpp"@g' third_party/rust/clang-sys/Cargo.toml"%,
        m%"sed -i 's/\("files":{\)[^}]*/\1/' third_party/rust/*/.cargo-checksum.json"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/bindgen/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/pollster/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/nss-rs/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/pkcs11-bindings/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/libsqlite3-sys/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/coreaudio-sys/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' third_party/rust/ohttp/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' security/manager/ssl/trust_anchors/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' security/manager/ssl/tests/unit/test_trust_anchors/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' build/workspace-hack/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' toolkit/crashreporter/client/app/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' toolkit/crashreporter/client/gtkbind/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' toolkit/crashreporter/client/cocoabind/Cargo.toml"%,
        m%"sed -i 's@"runtime"@"static"@g' netwerk/test/http3server/Cargo.toml"%,
        #   "cp .cargo/config.toml.in .cargo/config.toml",
        "export BUILDCONFIG_RS=$(pwd)/build/rust/mozbuild/buildconfig.rs",
        #   "cargo check --target=x86_64-unknown-linux-musl --offline",
        #   "unset BUILDCONFIG_RS",
        m%"sed -i 's@"--frozen"@"--offline"@g' build/RunCbindgen.py"%,

        #m%"sed -i 's@noexcept(true),@@g' memory/build/mozjemalloc.cpp"%,
        #m%"sed -i 's@noexcept(true),@@g' memory/build//mozmemory_wrap.cpp"%,
        #m%"sed -i 's@noexcept(true)@@g' memory/mozalloc/mozalloc.h"%,
        m%"sed -i "s@#include <vector>@#include <vector>\n#include <sys/types.h>@g" third_party/libwebrtc/modules/desktop_capture/desktop_capturer.h"%,
        m%"sed -i "s@#include <vector>@#include <vector>\n#include <sys/types.h>@g" third_party/libwebrtc/modules/desktop_capture/linux/wayland/egl_dmabuf.h"%,
        m%"sed -i 's@#include <linux/prctl.h>@// #include <linux/prctl.h>@g' third_party/libwebrtc/rtc_base/platform_thread_types.cc"%,
        m%"sed -i 's|ftruncate64|ftruncate|g' third_party/zucchini/chromium/base/files/file_posix.cc"%,
        ###
        m%"sed -i 's@SharedLibrary("mozsandbox")@Library("mozsandbox")@g' security/sandbox/linux/moz.build"%,
        m%"sed -i 's@SharedLibrary("mozwayland")@Library("mozwayland")@g' widget/gtk/mozwayland/moz.build"%,
        m%"sed -i 's@SharedLibrary("mozgtk")@Library("mozgtk")@g' widget/gtk/mozgtk/moz.build"%,
        m%"sed -i 's@SharedLibrary("fakeopenh264")@Library("fakeopenh264")@g' dom/media/gmp-plugin-openh264/moz.build"%,
        m%"sed -i 's@SharedLibrary("fake")@Library("fake")@g' dom/media/fake-cdm/moz.build"%,
        ###
        "sed -i 's@FORCE_SHARED_LIB = True@FORCE_STATIC_LIB = True@g' build/templates.mozbuild",
        ###
        "sed -i 's|SHARED_LIBRARY_NAME|STATIC_LIBRARY_NAME|g' config/external/mozinference/moz.build",
        "sed -i 's|SHARED_LIBRARY_NAME|STATIC_LIBRARY_NAME|g' config/external/lgpllibs/moz.build",
        "sed -i 's|SHARED_LIBRARY_NAME|STATIC_LIBRARY_NAME|g' config/external/gkcodecs/moz.build",
        "sed -i 's|SHARED_LIBRARY_NAME|STATIC_LIBRARY_NAME|g' config/external/sqlite/moz.build",

        ###

        #
        "sed -i 's|SYMBOLS_FILE|# SYMBOLS_FILE|g' config/external/gkcodecs/moz.build",
        "sed -i 's|SYMBOLS_FILE|assert(True)  # SYMBOLS_FILE|g' config/external/lgpllibs/moz.build",
        "sed -i 's|SYMBOLS_FILE|assert(True)  # SYMBOLS_FILE|g' config/external/sqlite/moz.build",
        "sed -i 's|SYMBOLS_FILE|# SYMBOLS_FILE|g' config/external/mozinference/moz.build",
        "sed -i 's|SYMBOLS_FILE|# SYMBOLS_FILE|g' media/ffvpx/libavutil/moz.build",
        "sed -i 's|SYMBOLS_FILE|# SYMBOLS_FILE|g' media/ffvpx/libavcodec/moz.build",
        #
        "sed -i 's|SHARED_LIBRARY_NAME|STATIC_LIBRARY_NAME|g' toolkit/library/moz.build",
        #
        "sed -i 's|SYMBOLS_FILE|assert(True)  # SYMBOLS_FILE|g' toolkit/library/moz.build",
        "sed -i 's|DLL_SUFFIX|LIB_SUFFIX|g' toolkit/library/moz.build",
        lib.functions.writeFile "toolkit/library/toolkit_lib.list" (""),
        ##
        #   lib.functions.writeFile "toolkit/library/build/lib.so" (""),

        #   "cp /usr/lib/libc.so toolkit/library/build/lib.so",
        # "cp /usr/lib/libnspr4.so toolkit/library/build/lib.so",
        # m%"printf "import sys\ndef gen_list(x):\n\treturn ''\n\nsys.stdout.write('')\n" > toolkit/library/build/dependentlibs.py"%,
        ##
        "sed -i 's|checks.append(check_textrel)|# checks.append(check_textrel)|g' python/mozbuild/mozbuild/action/check_binary.py",

        ###
        m%"sed -i 's@"shell"@@g' js/xpconnect/moz.build"%,
        m%"sed -i 's@"app",@@g' ipc/moz.build"%,
        #":>browser/installer/package-manifest.in",
        # m%"sed -i 's|@DLL_SUFFIX@|.a|g' browser/installer/package-manifest.in"%,
        # m%"sed -i 's|@BINPATH@/@DLL_PREFIX@xul@DLL_SUFFIX@||g' browser/installer/package-manifest.in"%,
        # m%"sed -i 's|@RESPATH@/dependentlibs.list||g' browser/installer/package-manifest.in"%,
        "head -n32 mozglue/interposers/env_interposer.cpp > /tmp/f",
        "mv /tmp/f mozglue/interposers/env_interposer.cpp",
        m%"sed -i 's@real_pthread_atfork = GET_REAL_SYMBOL(pthread_atfork);@// real_pthread_atfork = GET_REAL_SYMBOL(pthread_atfork);@g' mozglue/interposers/pthread_atfork_interposer.cpp"%,
        m%"sed -i 's@real_pthread_atfork(mozPthreadHandlers.handlers[i][idxPreFork]@pthread_atfork(mozPthreadHandlers.handlers[i][idxPreFork]@g' mozglue/interposers/pthread_atfork_interposer.cpp"%,
        m%"sed -i 's@browser_linkage = "standalone"@browser_linkage = "dependent"@g' browser/app/moz.build"%,
        m%"sed -i 's@ linkage=browser_linkage@ linkage=browser_linkage, mozglue="program"@g' browser/app/moz.build"%,
        ###
        m%"sed -i "s@#include <stdlib.h>@#include <stdlib.h>\n#include <cstdint>@g" xpcom/base/nsVersionComparator.h"%,
        ###
        m%"sed -i "s@defined(XP_LINUX)@defined(XP_LINUX) \&\& defined(__GLIBC__)@g" memory/build/Mutex.h"%,
        m%"sed -i 's@noexcept(true)@@g' memory/build/mozmemory.h"%,
        m%"sed -i 's@noexcept(true)@@g' memory/mozalloc/mozalloc.h"%,
        m%"sed -i 's@ (noexcept(true),@ (@g' memory/build/mozjemalloc.cpp"%,
        #
        m%"sed -i 's@moz_xmalloc@malloc@g' gfx/thebes/gfxFont.cpp gfx/skia/skia/src/ports/SkMemory_mozalloc.cpp"%,
        m%"sed -i "s@inline void\* @inline void\* bad__@g" gfx/graphite2/src/MozGrMalloc.h"%,
        #
        # m%"sed -i 's@"mozwayland",@@g' widget/gtk/moz.build"%,
        # m%"sed -i 's@"mozwayland",@@g' toolkit/library/moz.build"%,
        m%"sed -i 's@"mozwayland.c",@@g' widget/gtk/mozwayland/moz.build"%,
        #
        m%"sed -i 's@"/config/external/rlbox/rlbox_thread_locals.cpp"@@g' media/libsoundtouch/src/moz.build"%,
        #

        # m%"sed -i 's@if CONFIG["OS_ARCH"] != "WINNT" and CONFIG["COMPILE_ENVIRONMENT"]@if false@g' browser/app/moz.build"%,
        m%"echo 'LDFLAGS+=["/tmp/workdir/src/libdlopen.a", "-Wl,-z,stack-size=4194304"]' >> browser/app/moz.build"%,
        m%"echo 'LDFLAGS+=["/usr/lib/libfirefox-glxtest-dlopen.a"]' >> toolkit/xre/glxtest/moz.build"%,
        #
        m%"sed -i 's@NS_DECL_ISUPPORTS@NS_DECL_THREADSAFE_ISUPPORTS@g' xpcom/components/StaticComponents.cpp.in"%,
      ]
      @ (
        std.array.map
          (fun s =>
            m%"sed -i 's|%{s}||g' browser/installer/package-manifest.in"%
          )
          [
            "@BINPATH@/@DLL_PREFIX@xul@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozgtk@DLL_SUFFIX@",
            "@RESPATH@/dependentlibs.list",
            "@BINPATH@/@DLL_PREFIX@mozwayland@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozsqlite3@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@lgpllibs@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@gkcodecs@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozavutil@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozavcodec@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozinference@DLL_SUFFIX@",
            "@BINPATH@/@DLL_PREFIX@mozsandbox@DLL_SUFFIX@",
            "@RESPATH@/gmp-clearkey/0.1/@DLL_PREFIX@clearkey@DLL_SUFFIX@",
          ]
      )
      @ (
        std.array.map
          (fun s => m%"echo "CFLAGS += ['-D%{s}=firefox_expat_bundled__%{s}']" >> parser/expat/moz.build"%)
          (import "expat-symbols.json")
      )
      @ (
        std.array.map
          (fun s => m%"echo "CFLAGS += ['-D%{s}=firefox_cairo_bundled__%{s}']" >> gfx/cairo/cairo/src/moz.build"%)
          (import "cairo-symbols.json")
      )
      @ (
        std.array.map
          (fun s => m%"echo "CFLAGS += ['-D%{s}=firefox_cairo_bundled__%{s}']" >> media/libpng/moz.build"%)
          [
            "png_set_option",
            "png_error",
            "png_get_cICP",
            "png_get_eXIf",
            "png_get_eXIf_1",
            "png_resolve_file_gamma",
            "png_zlib_inflate",
            "png_handle_chunk",
            "png_set_cICP",
            "png_set_eXIf",
            "png_set_eXIf_1",
            "png_write_cICP",
          ]
      )
      @ [
        # m%"echo "CFLAGS += ['-Dg_unix_fd_list_get=firefox_bundled__g_unix_fd_list_get']" >> third_party/pipewire/libpipewire/moz.build"%,
        m%"sed -i 's@g_unix_fd_list_get(@bad__g_unix_fd_list_get(@g' third_party/pipewire/libpipewire/mozgio.cpp"%,
      ],

    configurePhase =
      let mozconfig =
        std.string.join
          "\n"
          (
            []
            @ (
              std.array.map
                (fun s => "ac_add_options %{s}")
                (
                  [
                    "--disable-bootstrap",
                    "--disable-jemalloc",
                    # "--disable-replace-malloc", # this can't be used with --disable-replace-malloc
                    "--host=x86_64-unknown-linux-musl",
                    "--target=x86_64-unknown-linux-musl",
                    # "--enable-project=js",
                    "--enable-application=browser",
                    "--disable-tests",
                    "--with-system-av1",
                    "--with-system-gbm",
                    "--with-system-icu",
                    "--with-system-jpeg",
                    "--with-system-libdrm",
                    "--with-system-libvpx",
                    "--with-system-nspr",
                    "--with-system-nss",
                    "--with-system-pipewire",
                    "--with-system-webp",
                    "--with-system-zlib",
                    # "--with-system-png",
                    "--with-system-libevent",
                    "--with-system-pipewire",
                    # "--enable-system-pixman",
                    "--with-system-pixman",
                    # "--with-system-ffi",
                    # "--disable-shared-js",
                    "--enable-linker=lld",
                    "--prefix=/usr",
                    "--disable-crashreporter",
                    #   "--without-intl-api",
                    #   "--disable-wasm-jspi",
                    # "--disable-wasm-simd",
                    "--disable-pulseaudio",
                    "--disable-accessibility",
                    "--disable-audio-backends",
                    "--with-libclang-path=/usr/lib",
                    "--enable-default-toolkit=cairo-gtk3-wayland-only",
                    #   "--without-intl-api",
                    "--disable-wasm-jspi",
                    "--without-wasm-sandboxed-libraries",
                    # "--with-ccache=sccache",
                    "--with-ccache=ccache",
                    "--disable-updater",
                    "--disable-elf-hack",
                    "--disable-profiling",
                    # "--disable-gecko-profiler", # https://github.com/mozilla-firefox/firefox/commit/9f293760650955b26edc694e956b7161ce1970e3#diff-b7936ea6415bd2f95c36e9b513f049fafb1eaa4f3c2f8b485a2dbc8571f65295
                    "--disable-js-shell",
                    "--disable-sandbox",
                    (if (!options.jumbo) then "--disable-unified-build" else "--enable-unified-build"),
                    "--disable-strip",
                    "--disable-install-strip",
                  ]
                  @ (
                    if debug then
                      [
                        "--enable-debug-symbols",
                        "--enable-debug",
                        "--disable-optimize",
                      ]
                    else
                      [
                        "--disable-debug-symbols",
                        "--disable-debug",
                        "--enable-optimize",
                      ]
                  )
                )
            )
            @ (
              std.array.map
                (fun s => "")
                [
                  # "MOZ_PARALLEL_BUILD="
                ]
            )
          )
      in
      [
        "echo 'writing mozconfig'",
        lib.functions.writeFile "mozconfig" mozconfig,
        # "p=$(($(nproc)+2))",
        # m%"echo "mk_add_options MOZ_PARALLEL_BUILD=${p}" >> mozconfig"%,
        "echo 'mozconfig written'",
      ],
    buildPhase = [
      "echo 'bulld phase starting'",
      "echo 'building with mach'",
      # "./mach build --verbose",
      "./mach build",
      "echo 'biuld phase done'",
    ],
    installPhase = [
      "echo 'install phase starting'",
      "echo 'installing with mach'",
      "DESTDIR=$DEST ./mach install",
      # "echo 'installing with cp'",

      # "install -dm0755 ${DEST}/usr/lib",
      # "cp -rv obj-x86_64-unknown-linux-musl/dist ${DEST}/usr/lib/firefox-dist",
      "(cd ${DEST}/usr/lib/firefox && rm firefox-bin && ln -s firefox firefox-bin)",
    ],

    neverInclude = [
      drvs.cairo,
      drvs.harfbuzz,
      drvs.gdkPixbuf,
      drvs.openssl,
    ],

    biDrvs = [
      drvs.gnutar & { priority = 1 },
      drvs.opensslFirefox,
      drvs.firefoxGlxtestDl,
      drvs.pythonFirefox,
      # drvs.muslShared,
      drvs.llvmFull,
      # drvs.musl,
      # drvs.muslBothRenamedDl,
      drvs.muslBothWeakDl,
      drvs.mimalloc & { priority = 1 },
      drvs.pyyaml,
      drvs.pkgconfMeson,
      drvs.rust,
      drvs.cbindgen,
      drvs.gnumake,
      drvs.sccache,
      drvs.nodejs,
      #   drvs.linuxHeaders,
      drvs.nasm,
      drvs.clangCc,
      drvs.llvmConfigStatic,
      drvs.libstdcppCompat,
      drvs.ccacheBin,
      drvs.pythonDlFunc,
    ],
    pDrvs = [
      drvs.zstd,
      #   drvs.alsaLibs,
      # drvs.zlibNg,
      # drvs.libffi,
      drvs.gtk3,
      drvs.gtk4,
      drvs.libicu,
      #   drvs.nspr,
      drvs.libvpx,
      # drvs.libjpegTurbo,
      #   drvs.ffmpeg,
      #   drvs.ncurses,
      #   drvs.nss,
      drvs.nssFirefox,
      drvs.pipewire,
      drvs.libevent,
      drvs.libaom,
      drvs.dav1d,
      drvs.libwebp,
      drvs.pciutils,
    ],
  },
}
& (import "firefox-deps.ncl")
