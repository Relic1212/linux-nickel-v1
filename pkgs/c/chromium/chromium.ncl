{
  lib,
  drvs,
  chromiumSourceUnpacked | lib.Package = {
    singleSource = {
      uri = "https://github.com/chromium-linux-tarballs/chromium-tarballs/releases/download/151.0.7922.71/chromium-151.0.7922.71-linux.tar.xz",
      sha256sum = "b0bafa1501f47ad27c96c9b5451bb000058ab40ee0dc945a066d3bd614e84a2f",
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
  chromium | lib.Package =
    let
      wasmNode = {
        uri = "https://registry.npmjs.org/@rollup/wasm-node/-/wasm-node-4.22.4.tgz",
        sha256sum = "ee49bf67bd9bee869405af78162d028e2af0fcfca80497404f56b1b99f272717"
      },
      copiumSrc = {
        uri = "https://codeberg.org/selfisekai/copium/archive/151.2.tar.gz",
        sha256sum = "8c036397ea69f98af09db5a8d304ec21f0ae55801f7d5c2eda7396e382fb2594",
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
        {
          src = wasmNode,
        },
        {
          src = copiumSrc,
        }
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
        ],
        EXTRA_LDFLAGS = [
          # "/tmp/workdir/src/dlopen.o",
          "/tmp/workdir/src/libdl_chromium.a",
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
          "clang_version=22",
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
          "use_system_libffi=true",
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
          "use_pulseaudio=false",
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
        ]
        in
        [
          "gn gen out/Bld --args='%{std.string.join " " args}'",
        ],

      preConfigurePhase = [
        lib.functions.writeFile "dlopen.c" (import "chromium_dlopen2.c" as 'Text),
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
        # "cp -r ./third_party/devtools-frontend/src/node_modules/@rollup/rollup-linux-x64-gnu ./third_party/devtools-frontend/src/node_modules/@rollup/rollup-linux-x64-musl",
        "rm -r third_party/devtools-frontend/src/node_modules/rollup",
        "mkdir -p third_party/devtools-frontend/src/node_modules/rollup",
        "tar xf /tmp/workdir/packed/%{wasmNode.sha256sum}/%{std.string.split "/" wasmNode.uri |>std.array.last } -C third_party/devtools-frontend/src/node_modules/rollup --strip-components=1",
        "mkdir copium",
        "tar xf /tmp/workdir/packed/%{copiumSrc.sha256sum}/%{std.string.split "/" copiumSrc.uri |>std.array.last } -C copium --strip-components=1",
        m%"sed -i 's|NODE_VERSION="v24.12.0"|NODE_VERSION="v25.9.0"|g' third_party/node/update_node_binaries"%,
        m%"sed -i 's@#include <sys/cdefs.h>@// #include <sys/cdefs.h> @g' base/allocator/partition_allocator/src/partition_alloc/shim/allocator_shim_internals.h"%,
        "python << 'EOF'\n%{import "patch.py" as 'Text}\n\nEOF\n",
        "sed -i 's@__THROW _NOEXCEPT@__THROW // _NOEXCEPT@g' base/allocator/partition_allocator/src/partition_alloc/shim/allocator_shim_internals.h",
        "python build/linux/unbundle/replace_gn_files.py --system-libraries fontconfig libvpx libaom opus",
        "sed -i 's@#include <linux/prctl.h>@// #include <linux/prctl.h>@g' third_party/webrtc/rtc_base/platform_thread_types.cc",
        "patch -p1 < copium/cr148-rust-1.95-bytemuck.patch",
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
      ],
      buildPhase = [
        "ninja -C out/Bld chrome",
        "ninja -C out/Bld chrome_sandbox",
        "echo 'built chrom, building rest'",
        "ninja -C out/Bld || echo failed",
      ],

      installPhase = [
        "DESTDIR=$DEST ninja -C out/Bld install",
        "install -dm0755 ${DEST}/usr/bin",
        "cp out/Bld/chrome ${DEST}/usr/bin",
        "cp out/Bld/chrome-wrapper ${DEST}/usr/bin/",
        "cp out/Bld/chrome_crashpad_handler ${DEST}/usr/bin/",
      ],

      llvmProvider,
      llvmProvider = drvs.llvmFull,
      biDrvs =
        [
          drvs.go_1_26,
          drvs.gn2435,
          drvs.pythonFull,
          llvmProvider,
          drvs.pkgconfMeson,
          drvs.samurai,
          drvs.bindgen,
          # drvs.rustWFmt,
          drvs.rustProfiler,
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
        ]
        @ (if options.unpack then [] else [drvs.chromiumSourceUnpacked]),
      pDrvs = [
        drvs.gtk4,
        drvs.gtk3,
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
      ],
    },
  libclangCompat | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/clang/22/lib/x86_64-unknown-linux-gnu",
      "cd ${DEST}/usr/lib/clang/22/lib/x86_64-unknown-linux-gnu",
      "ln -s /usr/lib/clang/22/lib/linux/libclang_rt.builtins-x86_64.a libclang_rt.builtins.a",
      #
      "install -dm0755 ${DEST}/usr/lib/clang/22/lib/x86_64-unknown-linux-musl",
      "cd ${DEST}/usr/lib/clang/22/lib/x86_64-unknown-linux-musl",
      "ln -s /usr/lib/clang/22/lib/linux/libclang_rt.builtins-x86_64.a libclang_rt.builtins.a",
    ]
  },
  cfiIgnoreList | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/clang/22/share",
      "touch ${DEST}/usr/lib/clang/22/share/cfi_ignorelist.txt",
    ]
  },
  cdefs | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/include/sys",
      lib.functions.writeFile "${DEST}/usr/include/sys/cdefs.h" (import "cdefs.h" as 'Text),
    ]
  },
  muslBothRenamedDl,
  muslChromium | lib.AutotoolsPackage =
    muslBothRenamedDl
    & {
      postInstallPhase | priority 1 =
        muslBothRenamedDl.postInstallPhase
        @ [

          # "objcopy --redefine-sym=localtime=musl__localtime libc.a",
          # "objcopy --redefine-sym=localtime_r=musl__localtime_r libc.a",
          # "objcopy --redefine-sym=localtime=musl__localtime libc.so",
          # "objcopy --redefine-sym=localtime_r=musl__localtime_r libc.so",
          "objcopy --redefine-sym=dlopen=dlopen_libc libc.so",
          # "objcopy -W dlsym libc.a",
          "objcopy --redefine-sym=dlsym=dlsym_libc libc.so",
          "objcopy --redefine-sym=dladdr=dladdr_libc libc.so",
          "objcopy --globalize-symbol stub_dlopen libc.so",
          "objcopy --globalize-symbol stub_dlsym libc.so",
          "objcopy --globalize-symbol stub_dladdr libc.so",
        ]
    }
}
