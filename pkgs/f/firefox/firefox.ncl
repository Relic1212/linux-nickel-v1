{
  lib,
  drvs,
  # firefoxJumbo | lib.Package =
  #   firefox
  #   & {
  #     options.jumbo = true,
  #   },
  firefox | lib.Package = {
    debug = true,
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
          "$(pkg-config --static --libs gtk+-3.0 libcap libpci)",
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
        # "echo '%{import "firefox_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
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
        # "export SCCACHE_LOG=debug",
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
        m%"echo 'LDFLAGS+=["/tmp/workdir/src/libdlopen.a"]' >> browser/app/moz.build"%,
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
        # (fun s => m%"sed -i 's@%{s}@firefox_expat_bundled__%{s}@g' parser/expat/expat/lib/*.c parser/expat/expat/lib/*.h"%)
          (fun s => m%"echo "CFLAGS += ['-D%{s}=firefox_expat_bundled__%{s}']" >> parser/expat/moz.build"%)
          [
            "XML_ParserFree",
            "XML_ExternalEntityParserCreate",
            "XML_UseParserAsHandlerArg",
            "XML_SetReturnNSTriplet",
            "XML_SetUserData",
            "XML_SetBase",
            "XML_GetBase",
            "XML_GetSpecifiedAttributeCount",
            "XML_GetIdAttributeIndex",
            "XML_SetElementHandler",
            "XML_SetCharacterDataHandler",
            "XML_SetProcessingInstructionHandler",
            "XML_SetCommentHandler",
            "XML_SetCdataSectionHandler",
            "XML_SetDefaultHandlerExpand",
            "XML_SetDoctypeDeclHandler",
            "XML_SetUnparsedEntityDeclHandler",
            "XML_SetNotationDeclHandler",
            "XML_SetNamespaceDeclHandler",
            "XML_SetExternalEntityRefHandler",
            "XML_SetExternalEntityRefHandlerArg",
            "XML_SetXmlDeclHandler",
            "XML_SetParamEntityParsing",
            "XML_SetHashSalt",
            "XML_Parse",
            "XML_GetBuffer",
            "XML_ParseBuffer",
            "XML_StopParser",
            "XML_ResumeParser",
            "XML_GetParsingStatus",
            "XML_GetErrorCode",
            "XML_GetCurrentByteIndex",
            "XML_GetCurrentLineNumber",
            "XML_GetCurrentColumnNumber",
            "XML_SetBillionLaughsAttackProtectionMaximumAmplification",
            "XML_SetBillionLaughsAttackProtectionActivationThreshold",
            "XML_SetReparseDeferralEnabled",
            "XML_ParserCreate_MM",
            "g_reparseDeferralEnabledDefault",
          ]
      )
      @ (
        std.array.map
          (fun s => m%"echo "CFLAGS += ['-D%{s}=firefox_cairo_bundled__%{s}']" >> gfx/cairo/cairo/src/moz.build"%)
          [
            "_cairo_clip_path_destroy",
            "_cairo_clip_create",
            "_cairo_clip_destroy",
            "__cairo_clip_all",
            "_cairo_clip_copy",
            "_cairo_clip_copy_path",
            "_cairo_clip_copy_region",
            "_cairo_clip_intersect_path",
            "_cairo_clip_intersect_clip",
            "_cairo_clip_equal",
            "_cairo_clip_translate",
            "_cairo_clip_transform",
            "_cairo_clip_copy_with_translation",
            "_cairo_clip_contains_extents",
            "_cairo_debug_print_clip",
            "_cairo_clip_get_extents",
            "_cairo_rectangle_list_create_in_error",
            "_cairo_rectangles_nil",
            "_cairo_clip_copy_rectangle_list",
            "_cairo_clip_reset_static_data",
            "_cairo_device_create_in_error",
            "_cairo_device_init",
            "_cairo_device_set_error",
            "_cairo_font_face_set_error",
            "_cairo_font_face_init",
            "_cairo_font_face_destroy",
            "_cairo_unscaled_font_init",
            "_cairo_unscaled_font_reference",
            "_cairo_unscaled_font_destroy",
            "_cairo_font_face_nil",
            "_cairo_font_face_nil_file_not_found",
            "_cairo_font_options_init_default",
            "_cairo_font_options_init_copy",
            "_cairo_font_options_compare",
            "_cairo_font_options_fini",
            "_cairo_font_options_set_round_glyph_positions",
            "_cairo_font_options_get_round_glyph_positions",
            "cairo_font_options_set_variations",
            "cairo_font_options_get_variations",
            "cairo_font_options_set_color_mode",
            "cairo_font_options_get_color_mode",
            "cairo_font_options_set_color_palette",
            "cairo_font_options_get_color_palette",
            "cairo_font_options_set_custom_palette_color",
            "cairo_font_options_get_custom_palette_color",
            "_cairo_format_from_pixman_format",
            "_cairo_content_from_pixman_format",
            "_cairo_image_surface_init",
            "_cairo_image_surface_create_for_pixman_image",
            "_cairo_image_surface_backend",
            "_pixman_format_from_masks",
            "_pixman_format_to_masks",
            "_cairo_format_to_pixman_format_code",
            "_cairo_image_surface_create_with_pixman_format",
            "_cairo_image_surface_create_with_content",
            "_cairo_format_from_content",
            "_cairo_format_bits_per_pixel",
            "_cairo_content_from_format",
            "_cairo_image_surface_create_similar",
            "_cairo_image_surface_snapshot",
            "_cairo_image_surface_map_to_image",
            "_cairo_image_surface_unmap_image",
            "_cairo_image_surface_finish",
            "_cairo_image_surface_assume_ownership_of_data",
            "_cairo_image_surface_source",
            "_cairo_image_surface_acquire_source_image",
            "_cairo_image_surface_release_source_image",
            "_cairo_image_surface_get_extents",
            "_cairo_image_surface_paint",
            "_cairo_image_surface_mask",
            "_cairo_image_surface_stroke",
            "_cairo_image_surface_fill",
            "_cairo_image_surface_glyphs",
            "_cairo_image_surface_get_font_options",
            "_cairo_image_surface_coerce",
            "_cairo_image_surface_coerce_to_format",
            "_cairo_image_surface_create_from_image",
            "_cairo_image_analyze_transparency",
            "_cairo_image_analyze_color",
            "_cairo_image_surface_clone_subimage",
            "_cairo_matrix_get_affine",
            "_cairo_matrix_multiply",
            "_cairo_matrix_transform_bounding_box",
            "_cairo_matrix_transform_bounding_box_fixed",
            "_cairo_matrix_compute_determinant",
            "_cairo_matrix_is_invertible",
            "_cairo_matrix_is_scale_0",
            "_cairo_matrix_compute_basis_scale_factors",
            "_cairo_matrix_is_integer_translation",
            "_cairo_matrix_has_unity_scale",
            "_cairo_matrix_is_pixel_exact",
            "_cairo_matrix_transformed_circle_major_axis",
            "_cairo_matrix_is_pixman_translation",
            "_cairo_matrix_to_pixman_matrix_offset",
            "_cairo_validate_text_clusters",
            "_cairo_operator_bounded_by_mask",
            "_cairo_operator_bounded_by_source",
            "_cairo_operator_bounded_by_either",
            "_cairo_half_from_float",
            "_cairo_get_locale_decimal_point",
            "_cairo_strtod",
            "_cairo_fopen",
            "_cairo_tmpfile",
            "_cairo_string_hash",
            "_cairo_intern_string",
            "_cairo_intern_string_reset_static_data",
            "_cairo_path_create_in_error",
            "_cairo_path_create",
            "_cairo_path_create_flat",
            "_cairo_path_append_to_context",
            "_cairo_pattern_init",
            "_cairo_pattern_init_copy",
            "_cairo_pattern_init_static_copy",
            "_cairo_pattern_init_snapshot",
            "_cairo_pattern_fini",
            "_cairo_pattern_create_copy",
            "_cairo_pattern_init_solid",
            "_cairo_pattern_init_for_surface",
            "_cairo_pattern_create_solid",
            "_cairo_pattern_create_foreground_marker",
            "_cairo_pattern_create_in_error",
            "cairo_pattern_create_mesh",
            "cairo_mesh_pattern_begin_patch",
            "cairo_mesh_pattern_end_patch",
            "cairo_mesh_pattern_line_to",
            "cairo_mesh_pattern_curve_to",
            "cairo_mesh_pattern_move_to",
            "cairo_mesh_pattern_set_control_point",
            "cairo_mesh_pattern_set_corner_color_rgb",
            "cairo_mesh_pattern_set_corner_color_rgba",
            "cairo_pattern_get_dither",
            "cairo_pattern_set_dither",
            "_cairo_pattern_pretransform",
            "_cairo_pattern_transform",
            "_cairo_radial_pattern_focus_is_inside",
            "_cairo_gradient_pattern_box_to_parameter",
            "_cairo_gradient_pattern_interpolate",
            "_cairo_gradient_pattern_fit_to_range",
            "_cairo_pattern_alpha_range",
            "_cairo_mesh_pattern_coord_box",
            "_cairo_gradient_pattern_is_solid",
            "_cairo_pattern_is_constant_alpha",
            "_cairo_pattern_is_clear",
            "_cairo_pattern_is_opaque",
            "_cairo_pattern_is_opaque_solid",
            "_cairo_pattern_analyze_filter",
            "_cairo_pattern_sampled_area",
            "_cairo_pattern_get_extents",
            "_cairo_pattern_get_ink_extents",
            "_cairo_linear_pattern_hash",
            "_cairo_radial_pattern_hash",
            "_cairo_pattern_hash",
            "_cairo_linear_pattern_equal",
            "_cairo_radial_pattern_equal",
            "_cairo_pattern_equal",
            "cairo_mesh_pattern_get_patch_count",
            "cairo_mesh_pattern_get_path",
            "cairo_mesh_pattern_get_corner_color_rgba",
            "cairo_mesh_pattern_get_control_point",
            "_cairo_pattern_reset_static_data",
            "_cairo_debug_print_pattern",
            "_cairo_pattern_black",
            "_cairo_pattern_clear",
            "_cairo_pattern_white",
            "_cairo_recording_surface_region_array_attach",
            "_cairo_recording_surface_region_array_remove",
            "_cairo_recording_surface_region_array_reference",
            "_cairo_recording_surface_get_path",
            "_cairo_recording_surface_replay_one",
            "_cairo_recording_surface_replay",
            "_cairo_recording_surface_replay_with_foreground_color",
            "_cairo_recording_surface_replay_with_transform",
            "_cairo_recording_surface_replay_with_clip",
            "_cairo_recording_surface_replay_and_create_regions",
            "_cairo_recording_surface_replay_region",
            "_cairo_recording_surface_get_bbox",
            "_cairo_recording_surface_get_ink_bbox",
            "cairo_recording_surface_get_extents",
            "_cairo_recording_surface_has_only_bilevel_alpha",
            "_cairo_recording_surface_has_only_op_over",
            "_cairo_recording_surface_has_tags",
            "_cairo_debug_print_recording_surface",
            "_cairo_region_create_in_error",
            "_cairo_region_init",
            "_cairo_region_init_rectangle",
            "_cairo_region_fini",
            "_cairo_region_create_from_boxes",
            "_cairo_region_get_boxes",
            "_cairo_scaled_font_set_error",
            "_cairo_scaled_font_map_destroy",
            "_cairo_scaled_font_fini",
            "_cairo_scaled_font_register_placeholder_and_unlock_font_map",
            "_cairo_scaled_font_init",
            "_cairo_scaled_font_reset_cache",
            "_cairo_scaled_font_unregister_placeholder_and_lock_font_map",
            "_cairo_scaled_font_freeze_cache",
            "_cairo_scaled_font_thaw_cache",
            "_cairo_scaled_font_set_metrics",
            "_cairo_scaled_font_attach_private",
            "_cairo_scaled_font_find_private",
            "_cairo_scaled_glyph_attach_private",
            "_cairo_scaled_glyph_find_private",
            "_cairo_scaled_font_create_in_error",
            "_cairo_scaled_font_reset_static_data",
            "_cairo_scaled_glyph_lookup",
            "_cairo_scaled_font_glyph_device_extents",
            "_cairo_scaled_font_glyph_approximate_extents",
            "_cairo_scaled_font_glyph_path",
            "_cairo_scaled_glyph_set_metrics",
            "_cairo_scaled_glyph_set_surface",
            "_cairo_scaled_glyph_set_path",
            "_cairo_scaled_glyph_set_recording_surface",
            "_cairo_scaled_glyph_set_color_surface",
            "_cairo_scaled_font_get_max_scale",
            "_cairo_scaled_font_has_color_glyphs",
            "_cairo_surface_create_for_rectangle_int",
            "_cairo_surface_subsurface_set_snapshot",
            "_cairo_surface_set_error",
            "_cairo_surface_detach_snapshot",
            "_cairo_surface_flush",
            "_cairo_surface_attach_snapshot",
            "_cairo_surface_has_snapshot",
            "_cairo_surface_begin_modification",
            "_cairo_surface_init",
            "cairo_surface_create_similar_image",
            "cairo_surface_set_device_scale",
            "_cairo_surface_paint",
            "_cairo_surface_create_in_error",
            "_cairo_surface_map_to_image",
            "_cairo_surface_unmap_image",
            "cairo_surface_map_to_image",
            "cairo_surface_unmap_image",
            "_cairo_surface_create_scratch",
            "_cairo_surface_release_device_reference",
            "_cairo_surface_has_mime_image",
            "cairo_surface_supports_mime_type",
            "_cairo_surface_copy_mime_data",
            "_cairo_surface_set_font_options",
            "_cairo_surface_get_extents",
            "cairo_surface_get_device_scale",
            "_cairo_surface_has_device_transform",
            "_cairo_surface_acquire_source_image",
            "_cairo_surface_default_acquire_source_image",
            "_cairo_surface_release_source_image",
            "_cairo_surface_default_release_source_image",
            "_cairo_surface_get_source",
            "_cairo_surface_default_source",
            "_cairo_surface_mask",
            "_cairo_surface_fill_stroke",
            "_cairo_surface_fill",
            "_cairo_surface_stroke",
            "_cairo_surface_show_text_glyphs",
            "_cairo_surface_tag",
            "_cairo_surface_supports_color_glyph",
            "_cairo_surface_set_resolution",
            "_cairo_int_surface_create_in_error",
            "_cairo_font_face_is_user",
            "_cairo_user_font_face_backend",
            "cairo_user_font_face_set_render_color_glyph_func",
            "cairo_user_font_face_get_render_color_glyph_func",
            "cairo_user_scaled_font_get_foreground_marker",
            "cairo_user_scaled_font_get_foreground_source",
            "_cairo_create_in_error",
            "_cairo_init",
            "_cairo_fini",
            "cairo_set_hairline",
            "cairo_tag_begin",
            "cairo_tag_end",
            "cairo_get_hairline",
            "_cairo_toy_font_face_reset_static_data",
            "_cairo_ft_to_cairo_error",
            "_cairo_scaled_font_is_ft",
            "_cairo_ft_face_decompose_glyph_outline",
            "_cairo_ft_font_face_backend",
            "cairo_ft_font_face_unset_synthesize",
            "cairo_ft_font_face_get_synthesize",
            "_cairo_ft_scaled_font_get_load_flags",
            "_cairo_ft_font_reset_static_data",
            "_cairo_pdf_surface_new_object",
            "_cairo_pdf_surface_update_object",
            "cairo_pdf_surface_add_outline",
            "cairo_pdf_surface_set_metadata",
            "cairo_pdf_surface_set_custom_metadata",
            "cairo_pdf_surface_set_page_label",
            "cairo_pdf_surface_set_thumbnail_size",
            "_cairo_pdf_surface_object_begin",
            "_cairo_pdf_surface_object_end",
            "_cairo_utf8_to_pdf_string",
            "_cairo_clip_path_reference",
          ]
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
                    # "--disable-debug",
                    # "--disable-debug-symbols",
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
    ],

    neverInclude = [
      drvs.cairo,
      drvs.harfbuzz,
      drvs.gdkPixbuf,
    ],

    biDrvs = [
      drvs.gnutar & { priority = 1 },
      drvs.pythonFirefox,
      # drvs.muslShared,
      drvs.llvmFull,
      # drvs.musl,
      # drvs.muslBothRenamedDl,
      drvs.muslBothWeakDl,
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
#
&
#
{
  lib,
  drvs,
  python,
  pythonFirefox | lib.AutotoolsPackage = {
    singleSource = python.singleSource,
    isStatic = false,
    extraConfigureFlags = [
      "--disable-profiling",
      "--disable-pystats",
      "--without-ensurepip",
      "--build=x86_64-unknown-linux-gnu",
      "--host=x86_64-unknown-linux-gnu",
      "--target=x86_64-unknown-linux-gnu",
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.opensslPic,
      drvs.zlibNgPic,
      drvs.ncursesPic,
      drvs.zstd,
      drvs.bzip2,
      drvs.readlinePic,
      drvs.muslShared,
      drvs.linuxHeaders,
      drvs.libffi,
      drvs.sqlitePic,
    ],
    postInstallPhase = [
      "cd $DEST/usr/bin",
      "ln -s python3 python",
    ]
  }
}
#
&
#
{
  lib,
  drvs,
  sqlite,
  sqlitePic | lib.AutotoolsPackage =
    sqlite
    & {
      buildEnv._isPic = true,
    },
}
#
&
#
{
  lib,
  drvs,
  nss,
  nssFirefox | lib.MakePackage =
    nss
    & {

      singleSource | priority 1 = {
        # uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_126_RTM/src/nss-3.126.tar.gz",
        # sha256sum = "7aa07c758be1453d82d739240b249ffb7aef0041be488067e1c0f348e1f9e337",
        uri = "https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_129_RTM/src/nss-3.129.tar.gz",
        sha256sum = "38baa3b0a18a3f674843473b549753c96419a0151abd1e7a9b214ce0493d0785",
      },
      enableParallel = false,
      options.args | priority 1 =
        nss.options.args
        @ [
          "-j 1",
          "--system-sqlite",
          "-t x64",
        ],
      pDrvs | priority 1 =
        nss.pDrvs
        @ [
          drvs.sqlite,
        ],
      preBuildPhase = [
        "set +e",
      ],
      installPhase | priority 1 = [
        "set -e",
        # "bas_e",
        # "ninja "
        "echo 'installPhase starting'",
        "install -dm0755 ${DEST}/usr/lib/pkgconfig",
        "install -dm0755 ${DEST}/usr/include/nss",
        "cp -rv ../dist/public/nss/* ${DEST}/usr/include/nss/",
        "cp -v ../dist/Release/lib/*.a ${DEST}/usr/lib/",
        # "cp ../dist/Release/lib/*.a ${DEST}/usr/lib/pkgconfig/",
        "echo 'sedding'",
        "sed -e 's@%prefix%@/usr@g' -e 's@%exec_prefix%@/usr/bin@g' -e 's@%libdir%@/lib@g' -e 's@%includedir%@/usr/include/nss@g' -e 's@%NSS_VERSION%@3.129@g' -e 's@%NSPR_VERSION%@1@g' $SRC/nss/pkg/pkg-config/nss.pc.in > ${DEST}/usr/lib/pkgconfig/nss.pc",
        "echo 'sedding done'",
        "cd ${DEST}/usr/lib/",
        # "mv libnssutil.a libnssutil3.a",
        # "mv libnss_static.a libnss3.a",
        # "mv libsmime.a libsmime3.a",
        # "mv libssl.a libssl3.a",
        # "llvm-objcopy --redefine-sym=C_GetInterface=nssckbi__C_GetInterface libnssckbi.a",
        "llvm-objcopy --redefine-sym=C_GetFunctionList=nssckbi__C_GetFunctionList libnssckbi.a",
      ],
      postInstallPhase = [
        "echo 'postInstallPhase starting'",
        "mv ${DEST}/usr/lib/libssl.a ${DEST}/usr/lib/libssl_nss.a"
      ]
    },
}
#
# &
# #
# {
#   lib,
#   drvs,
#   nssUnified | lib.Package =
#     let libs = [
#       "libcertdb.a",
#       "libcerthi.a",
#       "libcpputil.a",
#       "libcryptohi.a",
#       "libfreebl.a",
#       "libfreebl3.a",
#       "libfreebl_static.a",
#       "libfreeblpriv3.a",
#       # "libgcm-nodepend.a",
#       "libgcm.a",
#       "libghash-aes-x86_c_lib.a",
#       "libhw-acc-crypto-avx.a",
#       "libhw-acc-crypto-avx2.a",
#       # "libintel-gcm-wrap-nodepend_c_lib.a",
#       "libintel-gcm-wrap_c_lib.a",
#       "libjar.a",
#       "libmozpkix-testlib.a",
#       "libmozpkix.a",
#       "libnss3.a",
#       "libnss_static.a",
#       "libnssb.a",
#       "libnssckbi.a",
#       "libnssckfw.a",
#       "libnssdev.a",
#       "libnsspki.a",
#       "libnsssysinit.a",
#       "libnsssysinit_static.a",
#       "libnssutil.a",
#       "libnssutil3.a",
#       "libpk11wrap.a",
#       "libpk11wrap_static.a",
#       "libpkcs12.a",
#       "libpkcs7.a",
#       "libsectool.a",
#       "libsha-x86_c_lib.a",
#       "libsmime.a",
#       "libsmime3.a",
#       "libsoftokn.a",
#       "libsoftokn3.a",
#       "libsoftokn_static.a",
#       "libssl3.a",
#       "libssl_nss.a",
#     ]
#     in
#     {
#       buildPhase =
#         (std.array.map_with_index (fun index s => "mkdir %{index}\n(cd %{index} && ${AR} x /usr/lib/%{s}) ") libs)
#         @ [
#           "${AR} rcs libnss.a */*",
#         ],
#       installPhase = [
#         "install -dm0755 ${DEST}/usr/lib",
#         "install -m0755 libnss.a ${DEST}/usr/lib",
#       ],
#       biDrvs = [
#         drvs.nssFirefox,
#         drvs.llvm,
#       ]
#     }
# }
