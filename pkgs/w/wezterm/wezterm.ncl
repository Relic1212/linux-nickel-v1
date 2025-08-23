{
  lib,
  drvs,
  wezterm | lib.CargoPackage = {
    singleSource = {
      # uri = "https://github.com/wezterm/wezterm/archive/refs/tags/20240203-110809-5046fc22.tar.gz",
      # sha256sum = "3a02a68016ef48cdb2127308be20acafe94a568411e95b0e64dc590cf877b401",

      uri = "https://github.com/wezterm/wezterm/archive/6a493f88fab06a792308e0c704790390fd3c6232.tar.gz",
      sha256sum = "5edb9988a93fdea46e9e305e4fbbe886ed808cf200d006c4931969fe8cabd200"
    },

    nonCrateSourceInputs = [
      { src = singleSource },
      {
        src = {
          # uri = "https://github.com/wezterm/xcb-imdkit-rs/archive/215ce4b08ac9c4822e541efd4f4ffb1062806051.tar.gz",
          # sha256sum = "ccc3c08069eea1764eb72bf7e21e3e80bd9c0a528bae6eb41f7a4d68332ef63d",

          uri = "https://github.com/wezterm/xcb-imdkit-rs/archive/212330f7c6c37794d78061a773e8f4f9e4785bbb.tar.gz",
          sha256sum = "0391488f3be39af28afa2a43f334b062bd4ab6d06e217ddf26d8d447d2ce5e85",
        },
        dest = "vendor-xcb-imdkit-rs"
      },
      {
        src = {
          uri = "https://github.com/wez/finl_unicode/archive/a1892f26245529f2ef3877a9ebd610c96cec07a6.tar.gz",
          sha256sum = "181c938f6150fa392deebe3f8134a30f07e9b4ab13cf21ce620e4dad90dde311",
        },
        dest = "vendor-finl_unicode"
      },

      # https://github.com/gentoo/gentoo/blob/master/x11-terms/wezterm/wezterm-20240203.110809-r2.ebuild
      {
        src = {
          uri = "https://github.com/wez/freetype2/archive/e4586d960f339cf75e2e0b34aee30a0ed8353c0d.tar.gz",
          sha256sum = "2ca70adbd15be23569762319f7cac3cd92720f6042417916540bd120f18102f5"
        },
        dest = "deps/freetype/freetype2"
        # dest = "deps/freetype/freetype2/subprojects/dlg"
      },
      {
        src = {
          uri = "https://github.com/glennrp/libpng/archive/8439534daa1d3a5705ba92e653eda9251246dd61.tar.gz",
          sha256sum = "c73af438385b725238443ed9c23065b3ed614e04b24cd4b9560f1a587ce7f20f"
        },
        dest = "deps/freetype/libpng"
      },
      {
        src = {
          uri = "https://github.com/madler/zlib/archive/cacf7f1d4e3d44d871b605da3b647f07d718623f.tar.gz",
          sha256sum = "6d4d6640ca3121620995ee255945161821218752b551a1a180f4215f7d124d45"
        },
        dest = "deps/freetype/zlib"
      },
      {
        src = {
          uri = "https://github.com/harfbuzz/harfbuzz/archive/894a1f72ee93a1fd8dc1d9218cb3fd8f048be29a.tar.gz",
          sha256sum = "17eda8a9861d347a6e95cd2b3112301ce90dcc649b0e96623cc89c6ca4180e66"
        },
        dest = "deps/harfbuzz/harfbuzz"
      },
      {
        src = {
          uri = "https://github.com/wez/libssh-rs/archive/e57fdc813ed177738828ad73536f657cb2f91cf4.tar.gz",
          sha256sum = "e144d05c5cafeb10b1c7921b61cfb3d6882de856b4c0cf8b4af846a6d59acf37"
        },
        dest = "submodule-libssh-rs"
      },
      {
        src = {
          uri = "https://gitlab.com/libssh/libssh-mirror/-/archive/6ad455a8acfe6032c2a87cf83f2d20463c30f8af/libssh-mirror-6ad455a8acfe6032c2a87cf83f2d20463c30f8af.tar.gz",
          sha256sum = "42e7c11e4996d2b38e9fe8055dd2bf6da31fc1d7d13396127bab3e82845ba767"
        },
        dest = "submodule-libssh"
      }
    ],

    configurePhase = [
      # "rm ${SRC}/.cargo/config",
      m%"
            echo '
            [source.crates-io]
            replace-with = "vendored-sources"
            
            [source."git+https://github.com/wezterm/xcb-imdkit-rs.git?rev=212330f7c6c37794d78061a773e8f4f9e4785bbb#212330f7"]
            rev = "212330f7c6c37794d78061a773e8f4f9e4785bbb"
            git = "https://github.com/wezterm/xcb-imdkit-rs.git"
            replace-with = "vendored-sources"

            [source."git+https://github.com/wez/finl_unicode.git?branch=no_std#a1892f26245529f2ef3877a9ebd610c96cec07a6"]
            branch="no_std"
            git = "https://github.com/wez/finl_unicode.git"
            replace-with = "vendored-sources"

            [source.vendored-sources]
            directory = "vendor"

            ' > ${SRC}/.cargo/config.toml
            "%,
      "mv vendor-xcb-imdkit-rs vendor/xcb-imdkit-rs",
      "mv vendor-finl_unicode vendor/finl_unicode",
      "cp vendor/log-0.4.27/.cargo-checksum.json /tmp/workdir/src/vendor/xcb-imdkit-rs/.cargo-checksum.json",
      "cp vendor/log-0.4.27/.cargo-checksum.json /tmp/workdir/src/vendor/finl_unicode/.cargo-checksum.json",
      "(cd ${SRC} && patch -p1 < /tmp/workdir/patches/wezterm-git-no-dl.patch)",
    ],

    patches = [
      {
        sha256sum = "3e80b352ca40067beb2596d8d41d1e6202870a1b108e49d3fd63f69a5e1a12ec",
        file = "wezterm-git-no-dl.patch"
      }
    ],

    patchPhase = [],

    extraCargoFlags = [
      "--no-default-features",
      "--features wayland,vendored-fonts",
    ],
    extraEnv = {
      CARGO_FEATURE_USE_SYSTEM_LIB = "1",
      EXTRA_RUSTFLAGS =
        [
          "-C link-arg=-Wl,--push-state,--no-as-needed",
          "-C link-arg=-lc++",
          "-C link-arg=-lxkbcommon",
          "-C link-arg=-lxcb",
          "-C link-arg=-lXau",
          "-C link-arg=-lxcb-xkb",
          "-C link-arg=-lxcb",
          "-C link-arg=-lXau",
          "-C link-arg=-lxcb-shm",
        ]
        @ (
          let s = "-lEGL -lpthread -lpthread -lz -lgbm -lGLESv2 -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -ldl -lpthread -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link -ldrm_amdgpu -lelf -lz -ldrm_intel -ldrm -lpciaccess -lz -ldrm -lwayland-client -lwayland-server -lm -pthread -lrt -lffi"
          in
          std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " s)
        )
        @ [
          "-C link-arg=-Wl,--pop-state",
          # "-Awarnings",
        ],
    },

    postInstallPhase = [
      "install -d -m0755 ${DEST}/usr/share/applications",
      "install -d -m0755 ${DEST}/usr/share/fish/completions",
      "install -m0755 ${SRC}/assets/wezterm.desktop ${DEST}/usr/share/applications",
      "install -m0755 ${SRC}/assets/shell-completion/fish ${DEST}/usr/share/fish/completions/wezterm.fish",
    ],

    # crates = (lib.functions.filterCrates (import "wezterm-crates-newer.json")),
    crates = (lib.functions.filterCrates (import "wezterm-crates.json")),

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gperf,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libfontenc,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxcursor,
      drvs.libxcvt,
      drvs.libxfixes,
      drvs.libxfont2,
      drvs.libxkbfile,
      drvs.libxrender,
      drvs.libxshmfence,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesaExp,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xcbProto,
      drvs.xcbRenderutil,
      drvs.xcbUtilWm,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.xwayland,
      drvs.zlibNg,
      drvs.isoCodes,
      drvs.libxext,
      drvs.libxf86vm,
      drvs.libxrandr,
      drvs.xcbUtil,
      drvs.xcbUtilImage,
      drvs.xcbUtilKeysyms,
      drvs.xcbImdkit,
      drvs.libxkbcommonX11,
      drvs.libstdcppCompat,
      # drvs.git,
      drvs.libdlEgl,
    ],
  }
}
& {
  lib,
  drvs,
  libstdcppCompat | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib",
      "cd ${DEST}/usr/lib",
      "ln -s libc++.a libstdc++.a",
    ]
  }
}
