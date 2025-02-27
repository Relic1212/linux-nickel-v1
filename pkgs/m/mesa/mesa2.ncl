{
  lib,
  pkgs,
  _mesa | lib.MesonPackage
    = {

      biDrvs =
        lib.biMap [
          pkgs.libelf,
          pkgs.libdrm,
          pkgs.zlibNg,
          pkgs.pythonMako,
          pkgs.pythonPackaging,
          pkgs.pythonMarkupsafe,
          pkgs.libpciaccess,
          pkgs.libffi,
          pkgs.bison,
          pkgs.flex,
          pkgs.wayland,
          pkgs.waylandProtocols,
          pkgs.linuxHeaders,
          pkgs.m4
        ],
      extraMesonArgs = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        "-Ddri3=disabled",
        "-Dopengl=false",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dllvm=disabled",
        "-Dplatforms='wayland'",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
        "-Dgbm=enabled",
        "-Dzstd=disabled",
        "-Dzlib=enabled",
        "-Dglvnd=false",
        "-Dvulkan-drivers=",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs=''",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dgallium-xa=disabled",
        "-Dgallium-vdpau=disabled",
        "-Dgallium-va=disabled",
        "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=disabled",
        "-Dopencl-spirv=false",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=drm",
      ],
    },
}
& {
  drvs,
  mesa,
  lib,
  mesa2 | lib.MesonPackage
    = {

      biDrvs = [
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        # drvs.wayland,
        # drvs.waylandProtocols,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmFull,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
      ],
      extraMesonArgs = [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dplatforms=''",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
        "-Dgbm=enabled",
        "-Dzstd=disabled",
        "-Dzlib=enabled",
        "-Dglvnd=false",
        "-Dvulkan-drivers=",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs=''",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dgallium-xa=disabled",
        "-Dgallium-vdpau=disabled",
        "-Dgallium-va=disabled",
        "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=disabled",
        "-Dopencl-spirv=false",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=drm",
        "-Dintel-clc=enabled",
        "-Dllvm=enabled",
      ],

      # name|force="mesa2",
      singleSource | priority 1
        = {
          uri = "https://gitlab.freedesktop.org/mesa/mesa/-/archive/mesa-24.2.6/mesa-mesa-24.2.6.tar.gz",
          sha256sum = "5456ca326e84b5dda0dd93e91337ee337ac79cba15ee9d98bfae1002c24cfce1",
        },

      extraEnv = {
        PATH = "/usr/libexec:${PATH}"
      },
      patches | priority 1
        = [
          {
            file = "0.patch",
            sha256sum = "f5b6671dae52941927aeb8d86155b2f5d4f3966651673942b29218864c4fd08f"
          },
        ],
      preConfigurePhase | priority 1
        = [
          m%"
          sed -i 's@main()@print()@g' ${SRC}/bin/install_megadrivers.py
          sed -i 's@def print()@def main()@g' ${SRC}/bin/install_megadrivers.py

          for f in $(find ${SRC} -type f -name meson.build );
              do sed -i 's@shared_library@library@g' $f;
          done

          "%,
          m%"
          sed -i \
            "s@name_suffix : 'so',@name_suffix : 'a',@g" \
            ${SRC}/src/gallium/targets/dri/meson.build
          "%
        ],
      baseBuildinputPackages = std.array.filter (fun v => v.drvHash != drvs.llvm.drvHash) lib.MesonPackage.baseBuildinputPackages,
    },

  llvmConfigStatic | lib.Package
    = {
      installPhase = [
        m%"
          install -d -m0755 ${DEST}/usr/bin
          printf "#!/bin/sh
          case "\${1}" in
            "--shared-mode")
            exec echo "static"
            ;;
          esac

          exec /usr/bin/llvm-config.unwrapped "\$@"

          " > ${DEST}/usr/bin/llvm-config
          chmod +x ${DEST}/usr/bin/llvm-config
          "%,
        # m%"
        # install -d -m0755 ${DEST}/usr/libexec
        # ln -s ${DEST}/usr/bin/llvm-config-static ${DEST}/usr/libexec/llvm-config

        # "%
      ],
    },

  mesaOpengl | lib.MesonPackage
    =
      mesa2
      & {
        # name|force="mesa2",

        extraMesonArgs | priority 1 = lib.functions.replaceArrayElem "-Dopengl=false" "-Dopengl=true" mesa2.extraMesonArgs,

        postInstallPhase = [
          "cd ${DEST}/usr/lib/pkgconfig",
          "ln -s egl.pc opengl.pc",
        ]
      },

  mesaGlx | lib.MesonPackage
    =
      mesa2
      & {
        # name|force="mesa2",

        extraMesonArgs | priority 1 = 
        [
        "-Dgles1=disabled",
        "-Dxmlconfig=disabled",
        "-Dshared-llvm=disabled",
        "-Dgles2=enabled",
        "-Dgallium-nine=false",
        "-Ddri3=disabled",
        "-Dopengl=true",
        "-Dgallium-drivers=radeonsi,virgl,iris,i915,crocus",
        "-Dplatforms='x11,wayland'",
        "-Dcpp_rtti=false",
        "-Dshared-glapi=enabled",
        "-Dgbm=enabled",
        "-Dzstd=disabled",
        "-Dzlib=enabled",
        "-Dglvnd=false",
        "-Dvulkan-drivers=",
        "-Dshader-cache=disabled",
        "-Dexpat=disabled",
        "-Dvideo-codecs='all'",
        "-Dtools=''",
        "-Degl=enabled",
        "-Dglx-read-only-text=true",
        "-Dgallium-xa=disabled",
        "-Dgallium-vdpau=disabled",
        "-Dgallium-va=disabled",
        "-Dgallium-opencl=disabled",
        "-Dimagination-srv=false",
        "-Dglx=dri",
        "-Dopencl-spirv=false",
        "-Dosmesa=false",
        "-Dvulkan-beta=false",
        "-Degl-native-platform=drm",
        "-Dintel-clc=enabled",
        "-Dllvm=enabled",
      ],
      biDrvs|priority 1 = mesa2.biDrvs @ [
        drvs.wayland,
        drvs.waylandProtocols,
        
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
              drvs.xwayland,
              drvs.libxkbfile,
              drvs.openssl,
              drvs.xcbUtilWm,
              drvs.xcbUtilErrors,

              drvs.libxext,
              drvs.libxf86vm,
              drvs.libxrandr,
      ]

       
      },
}
& {
  lib,
  drvs,
  llvm,

  llvmFull
    | lib.CmakePackage
    = {
      sourceInputs = llvm.sourceInputs,
      cmakeDir = llvm.cmakeDir,
      generator = "Ninja",
      biDrvs = [
        drvs.pythonFull,
        drvs.linuxHeaders,
      ],
      cmakeExtraArgsRecord = {
        "-DCLANG_BUILD_TOOLS" = "ON",
        "-DCLANG_DEFAULT_CXX_STDLIB" = "libc++",
        "-DCLANG_DEFAULT_LINKER" = "lld",
        "-DCLANG_DEFAULT_RTLIB" = "compiler-rt",
        "-DCLANG_DEFAULT_UNWINDLIB" = "libunwind",
        "-DCLANG_ENABLE_ARCMT" = "OFF",
        "-DCLANG_ENABLE_CLANGD" = "OFF",
        # "-DCLANG_ENABLE_HLSL" = "OFF",
        "-DCLANG_ENABLE_STATIC_ANALYZER" = "OFF",
        "-DCLANG_INCLUDE_TESTS" = "OFF",
        "-DCLANG_LINK_CLANG_DYLIB" = "OFF",
        "-DCLANG_TOOL_AMDGPU_ARCH_BUILD" = "ON",
        "-DCLANG_TOOL_APINOTES_TEST_BUILD" = "OFF",
        "-DCLANG_TOOL_ARCMT_TEST_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_CHECK_BUILD" = "OFF",
        # "-DCLANG_TOOL_CLANG_DIFF_BUILD" = "OFF",
        # "-DCLANG_TOOL_CLANG_EXTDEF_MAPPING_BUILD" = "OFF",
        # "-DCLANG_TOOL_CLANG_FORMAT_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_FORMAT_VS_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_FUZZER_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_IMPORT_TEST_BUILD" = "OFF",
        # "-DCLANG_TOOL_CLANG_INSTALLAPI_BUILD" = "OFF",
        # "-DCLANG_TOOL_CLANG_REFACTOR_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_REPL_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_CLANG_SCAN_DEPS_BUILD:BOOL" = "OFF",
        "-DCLANG_TOOL_C_ARCMT_TEST_BUILD:BOOL" = "OFF",
        "-DCLANG_TOOL_C_INDEX_TEST_BUILD" = "OFF",
        "-DCLANG_TOOL_C_INDEX_TEST_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_NVPTX_ARCH_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_SCAN_BUILD_BUILD:BOOL" = "OFF",
        # "-DCLANG_TOOL_SCAN_BUILD_PY_BUILD:BOOL" = "OFF",
        "-DCLANG_TOOL_SCAN_VIEW_BUILD:BOOL" = "OFF",
        "-DCMAKE_EXE_LINKER_FLAGS" = "-static",
        "-DCOMPILER_RT_BUILD_BUILTINS" = true,
        "-DCOMPILER_RT_BUILD_CTX_PROFILE:BOOL" = "OFF",
        "-DCOMPILER_RT_BUILD_GWP_ASAN" = "OFF",
        "-DCOMPILER_RT_BUILD_LIBFUZZER" = "OFF",
        "-DCOMPILER_RT_BUILD_MEMPROF" = "OFF",
        "-DCOMPILER_RT_BUILD_ORC" = false,
        "-DCOMPILER_RT_BUILD_PROFILE" = "OFF",
        "-DCOMPILER_RT_BUILD_SANITIZERS" = "OFF",
        "-DCOMPILER_RT_BUILD_XRAY" = "OFF",
        "-DCOMPILER_RT_CXX_LIBRARY" = "libcxx",
        "-DCOMPILER_RT_SANITIZERS_TO_BUILD:STRING" = "''",
        "-DCOMPILER_RT_SCUDO_STANDALONE_BUILD_SHARED:BOOL" = "OFF",
        "-DCOMPILER_RT_TERMINFO_LIB" = "OFF",
        "-DCOMPILER_RT_USE_BUILTINS_LIBRARY" = true,
        "-DCOMPILER_RT_USE_LLVM_UNWINDER" = true,
        "-DDCOMPILER_RT_DEFAULT_TARGET_ONLY" = true,
        "-DLIBCXXABI_ENABLE_SHARED:BOOL" = "OFF",
        "-DLIBCXXABI_ENABLE_STATIC_UNWINDER:BOOL" = "ON",
        "-DLIBCXXABI_INSTALL_SHARED_LIBRARY:BOOL" = "OFF",
        "-DLIBCXXABI_USE_COMPILER_RT:BOOL" = "ON",
        "-DLIBCXX_ENABLE_SHARED:BOOL" = "OFF",
        "-DLIBCXX_ENABLE_STATIC_ABI_LIBRARY" = "ON",
        "-DLIBCXX_HAS_MUSL_LIBC:BOOL" = "ON",
        "-DLIBCXX_INCLUDE_TESTS:BOOL" = "OFF",
        "-DLIBCXX_INSTALL_SHARED_LIBRARY:BOOL" = "OFF",
        "-DLIBCXX_USE_COMPILER_RT:BOOL" = "ON",
        "-DLIBUNWIND_ENABLE_SHARED:BOOL" = "OFF",
        "-DLIBUNWIND_USE_COMPILER_RT:BOOL" = "ON",
        "-DLLDB_BUILD_INTEL_MPX" = "OFF",
        "-DLLDB_EDITLINE_USE_WCHAR" = "1",
        "-DLLDB_ENABLE_CURSES" = "OFF",
        "-DLLDB_ENABLE_LIBEDIT" = "OFF",
        "-DLLDB_ENABLE_LUA" = "OFF",
        "-DLLDB_ENABLE_PYTHON" = "OFF",
        "-DLLD_BUILD_TOOLS:BOOL" = "ON",
        "-DLLVM_ABI_BREAKING_CHECKS" = "FORCE_OFF",
        "-DLLVM_BUILD_LLVM_DYLIB" = "OFF",
        "-DLLVM_BUILD_STATIC" = "ON",
        "-DLLVM_BUILD_TESTS" = "OFF",
        "-DLLVM_BUILD_TOOLS:BOOL" = "ON",
        "-DLLVM_BUILD_UTILS:BOOL" = "OFF",
        "-DLLVM_CCACHE_BUILD:BOOL" = "ON",
        "-DLLVM_DYLIB_COMPONENTS" = "''",
        "-DLLVM_ENABLE_BACKTRACES" = "OFF",
        "-DLLVM_ENABLE_BINDINGS:BOOL" = "OFF",
        "-DLLVM_ENABLE_CRASH_OVERRIDES:BOOL" = "OFF",
        "-DLLVM_ENABLE_EH" = "OFF",
        "-DLLVM_ENABLE_LIBCXX" = "ON",
        "-DLLVM_ENABLE_LIBEDIT" = "OFF",
        "-DLLVM_ENABLE_LIBPFM" = "OFF",
        "-DLLVM_ENABLE_LIBXML2" = "OFF",
        "-DLLVM_ENABLE_LLD:BOOL" = "ON",
        "-DLLVM_ENABLE_OCAMLDOC" = "OFF",
        "-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR:BOOL" = "OFF",
        "-DLLVM_ENABLE_PIC" = "OFF",
        "-DLLVM_ENABLE_PROJECTS" = "'libclc;clang;lld;llvm'",
        "-DLLVM_ENABLE_RTTI" = "OFF",
        "-DLLVM_ENABLE_RUNTIMES" = "'libcxx;libcxxabi;compiler-rt;libunwind'",
        "-DLLVM_ENABLE_SHARED_LIBS" = "OFF",
        "-DLLVM_ENABLE_SPHINX" = "OFF",
        "-DLLVM_ENABLE_TERMINFO" = "OFF",
        "-DLLVM_ENABLE_UNWIND_TABLES" = "OFF",
        "-DLLVM_ENABLE_ZLIB" = "OFF",
        "-DLLVM_ENABLE_ZSTD" = "OFF",
        "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD" = "''",
        "-DLLVM_HOST_TRIPLE:STRING" = "x86_64-unknown-linux-musl",
        "-DLLVM_INCLUDE_BENCHMARKS" = "OFF",
        "-DLLVM_INCLUDE_DOCS" = "OFF",
        "-DLLVM_INCLUDE_EXAMPLES" = "OFF",
        "-DLLVM_INCLUDE_TESTS" = "OFF",
        "-DLLVM_INCLUDE_UTILS:BOOL" = "OFF",
        "-DLLVM_INSTALL_BINUTILS_SYMLINKS:BOOL" = "ON",
        "-DLLVM_LIBDIR_SUFFIX" = "",
        "-DLLVM_LINK_LLVM_DYLIB" = "OFF",
        "-DLLVM_PARALLEL_COMPILE_JOBS" = "$(nproc)",
        "-DLLVM_PARALLEL_LINK_JOBS" = "$(nproc)",
        "-DLLVM_TARGETS_TO_BUILD" = "'X86;AMDGPU'",
        # "-DLLVM_USE_SPLIT_DWARF" = "ON",
        "-DLLVM_USE_STATIC_ZSTD" = "ON",
        "-DLLVM_VERSION_SUFFIX" = "''",
      },

      postInstallPhase = [
        "cd ${DEST}/usr/bin",
        "mv llvm-config llvm-config.unwrapped",
      ],
    }
}
& {
  lib,
  drvs,
  pyyaml | lib.SetuptoolPackage
    = {
      singleSource = {
        uri = "https://github.com/yaml/pyyaml/archive/refs/tags/6.0.2.tar.gz",
        sha256sum = "9377c381ac3fccad8df73d96b5139ef8b1a2c57a0d913e95ab0a2275d66b5caa",
      },
      baseBuildinputPackages | priority 1
        =
          lib.Package.baseBuildinputPackages
          @ [
            drvs.pythonDynamic,
            drvs.pythonSetuptools,
            drvs.muslShared,
          ]
    }
}
