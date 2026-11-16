let system_libs = (
  std.string.join
    " "
    [
      # "fontconfig",
      # "libvpx",
      # "libaom",
      # "opus",
      ####

      #-absl+
      # "absl_algorithm",
      # "absl_base",
      # "absl_cleanup",
      # "absl_container",
      # "absl_crc",
      # "absl_debugging",
      # "absl_flags",
      # "absl_functional",
      # "absl_hash",
      # "absl_log",
      # "absl_log_internal",
      # "absl_memory",
      # "absl_meta",
      # "absl_numeric",
      # "absl_random",
      # "absl_status",
      # "absl_strings",
      # "absl_synchronization",
      # "absl_time",
      # "absl_types",
      # "absl_utility",
      #-absl-
      # "brotli",
      "crc32c",
      "dav1d",
      "double-conversion",
      # "ffmpeg", # wrong version
      "flac",
      # "flatbuffers", # wrong versoin
      "fontconfig",
      "freetype",
      "harfbuzz",
      "highway",
      # "icu", # missing dep
      "jsoncpp",
      "libaom",
      "libdrm",
      "libjpeg",
      # "libpng", # missing dep
      "libsecret",
      "libusb",
      "libvpx",
      "libwebp",
      "libxml",
      "libXNVCtrl",
      "libxslt",
      # "libyuv", # missing MJPGToNV12
      "openh264",
      "opus",
      "re2",
      # "simdutf", # missing symbol
      # "snappy", # don't even know what package this is supposed to come from
      "swiftshader-SPIRV-Headers",
      "swiftshader-SPIRV-Tools",
      # "vulkan-SPIRV-Headers", # no-webgpu only
      # "vulkan-SPIRV-Tools", # no-webgpu only
      # "vulkan_memory_allocator",
      "woff2",
      # "zlib",
      # "zstd",

      ####
    ]
)
in
{
  lib,
  drvs,
  chromium157SourceUnpacked | lib.Package = {
    singleSource = {
      uri = "https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/157.0.8103.38/chromium-157.0.8103.38-linux.tar.xz",
      sha256sum = "29904f34e47900e96b595e744a91ed23afc5f3060bf0e9f65817a043957ce7ad",
    },
    unpackPhase =
      let d = "/tmp/workdir/out/destdir/chromium-src" in
      [
        "mkdir -p %{d}",
        "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/%{std.string.split "/" singleSource.uri |>std.array.last } -C %{d} --strip-components=1",
        "mkdir -p %{d}/out",
      ],

    biDrvs = [
      drvs.gnutar & { priority = 1 },
    ],
  },
  chromium157 | lib.Package =
    let
      wasmNode = {
        uri = "https://registry.npmjs.org/@rollup/wasm-node/-/wasm-node-4.22.4.tgz",
        sha256sum = "ee49bf67bd9bee869405af78162d028e2af0fcfca80497404f56b1b99f272717"
      },
      copiumSrc = {
        uri = "https://codeberg.org/selfisekai/copium/archive/157.0.tar.gz",
        sha256sum = "ae64bd1c756f1567a56706a9ad6fdc657e6b9783131a626e04619d60ed125596",
      },
      muslSandboxPatch = {
        uri = "https://raw.githubusercontent.com/alpinelinux/aports/63664a5c5eff79b63e8538a34e13bd4dc25cbe73/community/chromium/musl-sandbox.patch",
        sha256sum = "a0b617eec291834abac9bd8affa9c4eebebe7388f601af8a67939925e9c1a4a0",
      },
      crubitPatch = {
        uri = "https://gitlab.archlinux.org/archlinux/packaging/packages/chromium/-/raw/main/chromium-157-crubit.patch",
        sha256sum = "eda45eaa5ba6c2ee86389200d4b758f0a06ffb32f3d06c3d0b60f2714c5d237f",
      },
      metadataPatch = {
        uri = "https://raw.githubusercontent.com/termux/termux-packages/73c95b106011dad7f9dc84f8eb38669c6a2e55ad/x11-packages/chromium-host-tools/cr-patches/6004-bugfix-ui-base-metadata-base_type_conversion.cc.patch",
        sha256sum = "021b7a65a8ea26e90a88d9f72fad0566022d9f505b97530afacdab53b7fb652e",
      }
    in
    {
      singleSource =
        if options.unpack then
          {
            uri = "https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/151.0.7922.71/chromium-151.0.7922.71-linux.tar.xz",
            sha256sum = "b0bafa1501f47ad27c96c9b5451bb000058ab40ee0dc945a066d3bd614e84a2f",
          }
        else
          null,

      sourceInputs = [
        # {
        #   src = wasmNode,
        # },
        {
          src = copiumSrc,
        },
        {
          src = muslSandboxPatch,
        },
        {
          src = crubitPatch,
        },
        {
          src = metadataPatch,
        },
      ],
      unpackPhase =
        if options.unpack then
          [
            "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/%{std.string.split "/" singleSource.uri |>std.array.last } -C /tmp/workdir/src --strip-components=1",
          ]
        else
          [
            "mount --bind /chromium-src /tmp/workdir/src",
            "mkdir -p /tmp/workdir/build/overlay/upper",
            "mkdir -p /tmp/workdir/build/overlay/work",
            "mount -t overlay overlay -o lowerdir=/tmp/workdir/src,upperdir=/tmp/workdir/build/overlay/upper,workdir=/tmp/workdir/build/overlay/work /tmp/workdir/src",
            "mkdir -p /tmp/workdir/build/out",
            "mount --bind /tmp/workdir/build/out /tmp/workdir/src/out",
          ],
      options = {
        unpack | default = false,
      },

      extraEnv = {
        RUSTC_BOOTSTRAP = "1",
        GOROOT = "/usr/lib/go",
      },
      buildEnv = {
        EXTRA_CFLAGS = [],
        EXTRA_CXXFLAGS = [],
        EXTRA_CPPFLAGS = [
          "-D_LIBCPP_PROVIDES_DEFAULT_RUNE_TABLE=1",
          # "$(pkg-config --cflags atk)",
          "-I/usr/include/libxml2",
        ],
        EXTRA_LDFLAGS = [
          # "/tmp/workdir/src/dlopen.o",
          # "/tmp/workdir/src/libdl_chromium.a",
          "/tmp/workdir/src/libdl_basic.a",
          "-Wl,--error-limit=0",
          "-lcertdb",
          "-lpk11wrap",
          "-lcerthi",
          "-lcryptohi",
          "-lnssb",
          "-lnssdev",
          "-lnsspki",
          "-lpkcs12",
          "-lpkcs7",
          # "-lLLVMCore",
          # "-lgallium_dri",
          "$(pkg-config --libs --static libbrotlidec libwoff2dec libwebp flac)",
        ],
      },
      separateBuildDir = false,

      configurePhase =
        let args = [
          "use_sysroot=false",
          "use_cups=false",
          "use_vaapi=false",
          # "use_nss_certs=false",
          "rust_sysroot_absolute=\"/usr\"",
          "rust_bindgen_root=\"/usr\"",
          "is_clang=true",
          "clang_use_chrome_plugins=false",
          # "clang_base_path=\"/usr</lib/clang/22\"",
          "clang_base_path=\"/usr\"",
          "clang_version=23",
          "custom_toolchain=\"//build/toolchain/linux/unbundle:default\"",
          "host_toolchain=\"//build/toolchain/linux/unbundle:default\"",
          # "target_cflags_cc=[\"-D_LIBCPP_PROVIDES_DEFAULT_RUNE_TABLE=1\"]",
          # "is_musl=true",
          # "rustc_version=\"rustc 1.95.0 (59807616e 2026-04-14) (built from a source tarball)\"",
          "rustc_version=\"yes\"",
          "angle_enable_vulkan=false",
          "angle_use_x11=false",
          "ozone_platform=\"wayland\"",
          "ozone_platform_x11=false",
          "rtc_use_x11=false",
          "treat_warnings_as_errors=false",
          "use_lld=true",
          "use_mold=false",
          # "use_system_libsync=true",
          # "generate_location_tags=false",
          "libcxx_is_shared=false",
          #
          "use_custom_libcxx=false",
          "v8_enable_sandbox=false",
          "use_llvm_libatomic=false",
          #
          "cc_wrapper=\"ccache\"",
          "is_component_build=false",
          "is_component_ffmpeg=false",
          # "enable_rust=false",
          "use_system_freetype=true",
          "use_system_harfbuzz=true",
          "use_system_lcms2=true",
          # "use_system_libdrm=true", #  not supported
          # "use_system_libffi=true",
          "use_system_libjpeg=true",
          # "use_system_libopenjpeg2=true",
          "use_system_libpng=true",
          # "use_system_libsync=true",
          "use_system_libtiff=true",
          "use_system_libwayland=true",
          # "use_system_minigbm=true",
          "use_system_zlib=true",
          "use_gio=false",
          "use_glib=false",
          "use_gtk=false",
          # "use_aura=false",
          # "use_atk=false",
          "has_native_accessibility=false",
          # "use_gtk=true",
          "use_qt5=false",
          "use_qt6=false",
          "toolchain_allows_use_partition_alloc_as_malloc=false",
          # "use_partition_alloc=false",
          "use_partition_alloc_as_malloc=false",
          "angle_shared_libvulkan=false",
          "angle_enable_vulkan_validation_layers=false",
          "dawn_enable_vulkan_validation_layers=false",
          "dawn_enable_spirv_validation=false",
          "angle_enable_vulkan_api_dump_layer=false",
          "angle_enable_swiftshader=false",
          "enable_swiftshader=false",
          "enable_swiftshader_vulkan=false",
          "dawn_use_swiftshader=false",
          # "use_pulseaudio=false",
          "use_pulseaudio=true",
          "is_asan=false",
          "is_msan=false",
          "is_lsan=false",
          "is_tsan=false",
          "is_ubsan=false",
          "dawn_enable_spirv_validation=false",
          "use_allocator_shim=false",
          # "simple_template_names=false",
          "is_official_build=true",
          "is_cfi=false",
          "use_cfi_cast=false",
          "use_cfi_diag=false",
          "use_cfi_icall=false",
          "use_cfi_recover=false",
          "use_thin_lto=false",
          "use_kerberos=false",
          "enable_remoting=false",
          "enable_hangout_services_extension=false",
          "enable_reporting=false",
          "disable_fieldtrial_testing_config=true",
          "enable_vr=false",
          "enable_arcore=false",
          "enable_openxr=false",
          ##
          # "chrome_root_store_cert_management_ui=false",
          # "enable_webui_certificate_viewer=false",
          # "enterprise_client_certificates=false",
          # "ignore_missing_widevine_signing_cert=false",
          # "rtc_builtin_ssl_root_certificates=false",
          # "support_cdm_server_certificate=false",
          # "use_nss_certs=false",
          # "enterprise_cloud_content_analysis=false",
          ##
          "pdf_enable_xfa=false",
          "icu_use_data_file=false",
          "v8_use_external_startup_data=false",
          # "headless_use_embedded_resources=true",
          "proprietary_codecs=true",
          "rtc_link_pipewire=true",
          "rtc_use_pipewire=true",
          "ffmpeg_branding=\"Chrome\"",
          "blink_symbol_level=0",
          "symbol_level=0",
          "v8_symbol_level=0",
          "concurrent_links=4",
          "rust_prebuilt_stdlib=false",
          "rust_crubit_root=\"/usr\"",
          "v8_monolithic=true",
          "v8_use_metagen=false",
          # "absl_build_tests=false",
          # "libsrtp_build_boringssl=false",
          # "rtc_build_ssl=false",
          # "rtc_build_opus=false",
          # "rtc_ssl_root=\"/usr/include\"",
          # "libsrtp_ssl_root=\"/usr/include\"",
          # "libsrtp_build_boringssl=false",
          # "crashpad_use_boringssl_for_http_transport_socket=false",
        ]
        in
        [
          m%"gn gen out/Bld --args="%{ std.string.replace m%"""% m%"\""% (std.string.join " \\\n" args)}""%,
          m%"printf "##### BEGIN GN ARGS MANIFEST #####\n" "%,
          "gn args --list out/Bld",
          m%"printf "##### END GN ARGS MANIFEST #####\n""%,
        ],
      remotePatches = [
        {
          src = {
            uri = "https://github.com/chromium/chromium/commit/ef51975a56ebee3fc72061d7b1b3df0d20acfff0.patch",
            sha256sum = "ac12b1aa03a7a18327e3e243b22fcfcf45ed1b42351481488337affe44cb5790"
          },
          reverse = true,
        },
      ],
      eofPatches = [
        {
          # revert https://github.com/signalapp/webrtc/commit/a0253ec15b3d3072fb35d6be29ba9224c36f9dd7
          patch = import "chromium157-webrtc-pw-1.4.patch" as 'Text,
          subdir = "/third_party/webrtc",
        },

        # {
        #   # revert  https://github.com/chromium/chromium/commit/72777c30be767d4f192f2a3ca94e838e0b83550e
        #   patch = import "chromium157-string2.patch" as 'Text,
        #   subdir = "",
        # },
      ],

      preConfigurePhase = [
        "(patch -p1 < /tmp/workdir/packed/%{muslSandboxPatch.sha256sum}/musl-sandbox.patch)",
        "(patch -p1 < /tmp/workdir/packed/%{crubitPatch.sha256sum}/chromium-157-crubit.patch)",
        "(patch -p1 < /tmp/workdir/packed/%{metadataPatch.sha256sum}/6004-bugfix-ui-base-metadata-base_type_conversion.cc.patch)",
        lib.functions.writeFile "dlopen_basic.c" (import "chromium_empty_dlopen.c" as 'Text),
        "${CC} ${CFLAGS} -Werror -fPIC -c dlopen_basic.c -o dlopen_basic.o", # also gets into some (currently) shared libs
        "llvm-ar rcs libdl_basic.a dlopen_basic.o",
        "llvm-ranlib libdl_basic.a",
        lib.functions.writeFile "dlopen.c" (import "chromium_dlopen.c" as 'Text), # TODO: sometimes it tries to dlopen libpulse.so.0
        "${CC} ${CFLAGS} -Werror -fPIC -c dlopen.c -o dlopen.o", # also gets into some (currently) shared libs
        "llvm-ar rcs libdl_chromium.a dlopen.o",
        "llvm-ranlib libdl_chromium.a",
        "sed -i 's|generate_location_tags = true|generate_location_tags = false|g' build/config/gclient_args.gni",
        # m%"sed -i 's@lib/x86_64-unknown-linux-gnu/libclang_rt.builtins.a@lib/linux/libclang_rt.builtins-x86_64.a@g' tools/clang/scripts/package.py"%,
        "mkdir -p third_party",
        "rm -rf third_party/rust-toolchain",
        "ln -s /usr third_party/rust-toolchain",
        # "ln -s /usr/share third_party/rust-toolchain/share",
        "rm -rf third_party/node/linux/node-linux-x64/bin",
        "mkdir -p third_party/node/linux/node-linux-x64",
        "ln -s /usr/bin third_party/node/linux/node-linux-x64/bin",
        "rm -f third_party/cpython3/host/bin/python3",
        "(cd third_party/cpython3/host/bin && ln -s /usr/bin/python3 python3)",
        m%"sed -i 's@"-fdiagnostics-show-inlining-chain"@@g' build/config/compiler/BUILD.gn"%,
        m%"sed -i 's@"-fno-lifetime-dse"@@g' build/config/compiler/BUILD.gn"%,
        m%"sed -i 's@"-Wno-unused-but-set-global",@@g' build/config/compiler/BUILD.gn"%,
        # m%"sed -i 's@"-Wno-unused-but-set-global"@"-D_LIBCPP_PROVIDES_DEFAULT_RUNE_TABLE=1"@g' build/config/compiler/BUILD.gn"%,
        m%"sed -i 's@"-Wno-unsafe-buffer-usage-in-static-sized-array"@@g' build/config/compiler/BUILD.gn"%,
        m%"sed -i 's@x86_64-unknown-linux-gnu@x86_64-unknown-linux-musl@g' build/config/compiler_cpu_abi.gn"%,
        m%"sed -i 's@x86_64-unknown-linux-gnu@x86_64-unknown-linux-musl@g' build/config/clang/BUILD.gn"%,
        m%"sed -i 's@x86_64-unknown-linux-gnu@x86_64-unknown-linux-musl@g' build/config/rust.gni"%,
        m%"sed -i 's@x86_64-unknown-linux-gnu@x86_64-unknown-linux-musl@g' build/rust/known-target-triples.txt"%,
        m%"sed -i 's@"-fsanitize-ignore-for-ubsan-feature=@#"-fsanitize-ignore-for-ubsan-feature=@g' build/config/sanitizers/sanitizers.gni"%,
        "sed -i 's@#define HAVE_EXECINFO_H 1@// #define HAVE_EXECINFO_H 1@g' third_party/swiftshader/third_party/llvm-subzero/build/Linux/include/llvm/Config/config.h",
        "sed -i 's@struct mallinfo mi@// struct mallinfo mi@g' third_party/swiftshader/third_party/llvm-subzero/lib/Support/Unix/Process.inc",
        "sed -i 's@mi = ::mallinfo()@// mi = ::mallinfo()@g' third_party/swiftshader/third_party/llvm-subzero/lib/Support/Unix/Process.inc",
        "sed -i 's@return mi.uordblks;@return 0;@g' third_party/swiftshader/third_party/llvm-subzero/lib/Support/Unix/Process.inc",
        # "sed -i 's@#include <sys/cdefs.h>@// #include <sys/cdefs.h>@g' third_party/libsync/src/include/ndk/sync.h",
        ##
        # "sed -i 's@__BEGIN_DECLS@// __BEGIN_DECLS@g' third_party/libsync/src/include/ndk/sync.h",
        # "sed -i 's@__END_DECLS@// __END_DECLS@g' third_party/libsync/src/include/ndk/sync.h",
        # "sed -i 's@__BEGIN_DECLS@// __BEGIN_DECLS@g' third_party/libsync/src/include/android/sync.h",
        # "sed -i 's@__END_DECLS@// __END_DECLS@g' third_party/libsync/src/include/android/sync.h",
        ##
        ##
        # m%"sed -i 's@__BEGIN_DECLS@extern "C" {@g' third_party/libsync/src/include/ndk/sync.h"%,
        # m%"sed -i 's@__END_DECLS@}@g' third_party/libsync/src/include/ndk/sync.h"%,
        # m%"sed -i 's@__BEGIN_DECLS@extern "C" {@g' third_party/libsync/src/include/android/sync.h"%,
        # m%"sed -i 's@__END_DECLS@}@g' third_party/libsync/src/include/android/sync.h"%,
        ##
        "mkdir -p third_party/dawn/tools/golang",
        "ln -s /usr third_party/dawn/tools/golang/linux-amd64",
        "mkdir -p /tmp/workdir/build/home",
        "export HOME=/tmp/workdir/build/home",
        "rm third_party/gperf/cipd/bin/gperf",
        "ln -s /usr/bin/gperf third_party/gperf/cipd/bin/gperf",
        "rm third_party/devtools-frontend/src/third_party/esbuild/esbuild",
        "ln -s /usr/bin/esbuild third_party/devtools-frontend/src/third_party/esbuild/esbuild",
        "rm buildtools/linux64/gn",
        "ln -s /usr/bin/gn buildtools/linux64/gn",
        # "cp -r ./third_party/devtools-frontend/src/node_modules/@rollup/rollup-linux-x64-gnu ./third_party/devtools-frontend/src/node_modules/@rollup/rollup-linux-x64-musl",
        # "rm -r third_party/devtools-frontend/src/node_modules/rollup",
        # "mkdir -p third_party/devtools-frontend/src/node_modules/rollup",
        # "tar xf /tmp/workdir/packed/%{wasmNode.sha256sum}/%{std.string.split "/" wasmNode.uri |>std.array.last } -C third_party/devtools-frontend/src/node_modules/rollup --strip-components=1",
        "mkdir copium",
        "tar xf /tmp/workdir/packed/%{copiumSrc.sha256sum}/%{std.string.split "/" copiumSrc.uri |>std.array.last } -C copium --strip-components=1",
        m%"sed -i 's|NODE_VERSION="v24.12.0"|NODE_VERSION="v26.10.0"|g' third_party/node/update_node_binaries"%,
        m%"sed -i 's@#include <sys/cdefs.h>@// #include <sys/cdefs.h> @g' base/allocator/partition_allocator/src/partition_alloc/shim/allocator_shim_internals.h"%,
        "python << 'EOF'\n%{import "patch.py" as 'Text}\n\nEOF\n",
        "sed -i 's@__THROW _NOEXCEPT@__THROW // _NOEXCEPT@g' base/allocator/partition_allocator/src/partition_alloc/shim/allocator_shim_internals.h",
        "python build/linux/unbundle/replace_gn_files.py --system-libraries %{system_libs}",
        "sed -i 's@#include <linux/prctl.h>@// #include <linux/prctl.h>@g' third_party/webrtc/rtc_base/platform_thread_types.cc",
        "patch -p1 < copium/cr148-rust-1.95-bytemuck.patch",
        # "patch -p1 < copium/cr157-crubit-fix-rs_bindings_from_cc-breakages.patch",
        m%"sed -i 's@#include <sys/cdefs.h>@// #include <sys/cdefs.h>@g' third_party/crashpad/crashpad/compat/linux/sys/ptrace.h"%,

        # m%"sed -i 's@= res_ninit@= res_init@g' net/dns/public/scoped_res_state.cc"%,
        # m%"sed -i "s@ScopedResState::ScopedResState() {\n#if BUILDFLAG(IS_OPENBSD) || BUILDFLAG(IS_FUCHSIA)@ScopedResState::ScopedResState() {\n#if BUILDFLAG(IS_OPENBSD) || BUILDFLAG(IS_FUCHSIA) || defined(__GUN_SOURCE)@g" net/dns/public/scoped_res_state.cc"%,
        m%"sed -i 's@res_nclose@// res_nclose@g' net/dns/public/scoped_res_state.cc"%,

        # m%"sed -i 's@"//build/config/compiler:sanitize_c_array_bounds",@# "//build/config/compiler:sanitize_c_array_bounds",@g' build/config/BUILDCONFIG.gn"%,
        m%"sed -i 's@condition = !(is_asan && target_cpu == "x86") && !is_wasm@condition = false # !(is_asan && target_cpu == "x86") && !is_wasm@g' build/config/compiler/BUILD.gn"%,
        m%"sed -i 's@condition = !is_wasm@condition = false # !is_wasm@g' build/config/compiler/BUILD.gn"%,
        # m%"sed -i 's@#if !defined(COMPONENT_BUILD)@#if 0@g' base/files/scoped_file_linux.cc"%,
        # m%"sed -i 's@const auto iter = request_sources_map_.find(request)@const auto iter = request_sources_map_.find(raw_ref<const PermissionRequest>(request))@g' components/permissions/permission_request_manager.cc"%,
        m%"sed -i "s@request_sources_map_.find(request)@request_sources_map_.find(raw_ref<PermissionRequest>(*const_cast<PermissionRequest*>(\&request)))@g" components/permissions/permission_request_manager.cc"%,
        "sed -i 's@std::string::const_iterator@std::string_view::const_iterator@g' net/cookies/cookie_util.cc",
        "sed -i 's@contains(profile)@contains(const_cast<Profile*>(profile))@g' chrome/browser/ui/startup/profile_launch_observer.cc",
        "sed -i 's@OutputToStreamWithPrefixImpl@// OutputToStreamWithPrefixImpl@g' base/debug/stack_trace.cc",
        "sed -i 's|shared_library|static_library|g' ui/gl/BUILD.gn",
        "sed -i 's@libEGL.so@obj/ui/gl/libEGL.a@g' chrome/BUILD.gn",
        "sed -i 's@libGLESv2.so@obj/ui/gl/libGLESv2.a@g' chrome/BUILD.gn",
        "sed -i 's|int getaddrinfo|int bad_getaddrinfo|g' sandbox/linux/services/libc_interceptor.cc",

        # "rm -rf third_party/wayland",
        # "rm -rf third_party/wayland-protocols",
        m%"sed -i "s@#include <gbm.h>@#include <gbm.h>\n#include <sys/types.h>@g" third_party/webrtc/modules/desktop_capture/linux/wayland/egl_dmabuf.h"%,

        # Needed on selinux for some reason 
        m%" sed -i "s@case __NR_pwrite64:@case __NR_pwrite64:\n\t    case __NR_pwritev2:@g" sandbox/policy/linux/bpf_gpu_policy_linux.cc"%,
        m%"sed -i 's@u8::max_value()@u8::MAX@g' third_party/rust/chromium_crates_io/vendor/qr_code-v2/src/structured.rs"%,

        # https://github.com/v8/v8/commit/d3f0ec122bd234aa82347cc0e838c8fae8cd6565
        m%"sed -i 's@#define V8_USE_ADDRESS_SANITIZER 1@//#define V8_USE_ADDRESS_SANITIZER 1@g' v8/src/base/macros.h"%,
        m%"sed -i 's@#define V8_USE_MEMORY_SANITIZER 1@//#define V8_USE_MEMORY_SANITIZER 1@g' v8/src/base/macros.h"%,
        m%"sed -i 's@#define V8_USE_UNDEFINED_BEHAVIOR_SANITIZER 1@//#define V8_USE_UNDEFINED_BEHAVIOR_SANITIZER 1@g' v8/src/base/macros.h"%,
      ],
      buildPhase = [
        "ninja -C out/Bld -j$(nproc) chrome",
        "ninja -C out/Bld chrome_sandbox",
        "echo 'built chrome, building rest'",
        "ninja -C out/Bld || echo failed",
      ],

      installPhase = [
        "DESTDIR=$DEST ninja -C out/Bld install",
        "install -dm0755 ${DEST}/usr/bin",
        "install -dm0755 ${DEST}/usr/lib/chromium/extensions",
        "strip out/Bld/chrome", # 2.1 gb -> 310 mb
        "cp out/Bld/chrome ${DEST}/usr/lib/chromium/",
        "cp out/Bld/chrome-wrapper ${DEST}/usr/lib/chromium/",
        "cp out/Bld/chrome_crashpad_handler ${DEST}/usr/lib/chromium/",
        "cp out/Bld/chrome_sandbox ${DEST}/usr/lib/chromium/",
        "cp -r out/Bld/locales ${DEST}/usr/lib/chromium/locales",
        "cp out/Bld/resources.pak ${DEST}/usr/lib/chromium/",
        "cp out/Bld/chrome_100_percent.pak ${DEST}/usr/lib/chromium/",
        "(cd ${DEST}/usr/bin && ln -s /usr/lib/chromium/chrome chrome)",
      ],

      llvmProvider,
      llvmProvider = drvs.llvmFull,
      biDrvs =
        [
          # drvs.flatbuffers,
          drvs.gnupatch & { priority = 1 }, #  Some fuzzyness needed for Alpine patch
          drvs.go_1_26,
          # drvs.gn2435,
          drvs.gn2436,
          # drvs.pythonFull,
          drvs.pythonDl,
          llvmProvider,
          drvs.pkgconfMeson,
          drvs.samurai,
          drvs.bindgen157,
          # drvs.rustWFmt,
          # drvs.rustProfiler,
          drvs.rust,
          # drvs.muslShared,
          # drvs.muslBothRenamedDl,
          drvs.muslChromium,
          drvs.libclangCompat,
          drvs.cfiIgnoreList,
          drvs.nodejs,
          drvs.gnutar & { priority = 1 },
          drvs.ccacheBin,
          drvs.gperf,
          drvs.esbuild,
          drvs.libemptyAtomic,
          drvs.libempty,
          # drvs.gcc, # libgcc
          drvs.cdefs,
          drvs.mesaChromium,
          drvs.glSymlink, # https://github.com/JumpingYang001/webrtc/commit/839b657b184b1afa563f6456b6caeac7c25dcb23
          # drvs.libcryptoEmpty & { priority = 1 },
          # drvs.libempty,
          drvs.opensslChromium,
          drvs.pipewireChromium,
          drvs.chromiumCrubitSource,
          drvs.chromiumCrubit,
        ]
        @ (if options.unpack then [] else [drvs.chromium157SourceUnpacked]),

      neverInclude = [
        drvs.mesa2,
        drvs.pipewire,
        drvs.openssl,
        # drvs.abseilCpp,
      ],
      pDrvs = [
        # drvs.minizipNg,
        drvs.crc32c,
        drvs.doubleConversion,
        drvs.openh264,
        drvs.flac,
        drvs.dav1d,
        drvs.highway,
        drvs.libicu,
        # drvs.simdutf,
        drvs.libyuv,
        # drvs.abseilCppChromium,
        drvs.re2,
        # drvs.zstd,
        # drvs.brotli,
        drvs.woff2,
        drvs.libwebp,
        drvs.jsoncpp,
        drvs.libxml2,
        drvs.libxslt,
        # drvs.gtk4,
        # drvs.gtk3,
        # drvs.harfbuzz,
        drvs.pango,
        # drvs.atSpi2Core,
        drvs.libjpegTurbo,
        # drvs.eudev,
        drvs.pipewire,
        drvs.lcms,
        drvs.pciutils,
        # drvs.highway,
        # drvs.libicu,
        drvs.libvpx,
        drvs.libaom,
        # drvs.libopus,
        drvs.curl,
        drvs.nss,
        drvs.pulseaudio17,
      ],
    },
}
