{
  lib,
  drvs,
  _CargoFetcher,
  cosmicXdgDesktopPortalSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/xdg-desktop-portal-cosmic/archive/refs/tags/epoch-1.0.0-alpha.7.tar.gz",
        sha256sum = "330efa06b12560fcdd0c2238107d31d8f5776d2512c76dab8b9027a640446c60"
      },
      outputSha256sum = "7776bbab4a448d061225d8e0648f1d5887145366bed6b7eb2b5c0509911c804e"
    },
}
& {
  lib,
  drvs,
  cosmicXdgDesktopPortal | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"clang-sys\/runtime"@"clang-sys\/static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
    ],

    extraEnv = {
      # https://github.com/NixOS/nixpkgs/pull/264517#issuecomment-1817817060
      EXTRA_RUSTFLAGS =
        [
          "-C link-arg=-Wl,--push-state,--no-as-needed",
          "-C link-arg=-lc++",

          # pkg-config --libs --static libinput
          "-C link-arg=-linput",
          "-C link-arg=-lm",
          "-C link-arg=-ludev",
          "-C link-arg=-pthread",
          "-C link-arg=-levdev",
          "-C link-arg=-lrt",
          "-C link-arg=-lmtdev",
          # input
          "-C link-arg=-lcap", # elogind
          "-C link-arg=-L/usr/lib/clang/20/lib/linux",
          "-C link-arg=-lclang_rt.builtins-x86_64",
        ]
        @ (
          let s = "-lEGL -lpthread -lpthread -lz -lgbm -lGLESv2 -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -ldl -lpthread -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link -ldrm_amdgpu -lelf -lz -ldrm_intel -ldrm -lpciaccess -lz -ldrm -lwayland-client -lwayland-server -lm -pthread -lrt -lffi"
          in
          std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " s)
        )
        @ [
          "-C link-arg=-Wl,--pop-state",
        ],

      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
    },
    cargoFlags,
    target,

    buildPhase = [
      "make ARGS+=\"%{std.string.join " " cargoFlags}\" prefix=/usr",
    ],
    installPhase = [
      "make TARGET=\"%{target}/release\" prefix=/usr DESTDIR=$DEST install",
    ],

    postInstallPhase = [
      m%"sed -i 's|\/bin\/false|\/usr\/bin\/false|g' ${DEST}/usr/share/dbus-1/services/org.freedesktop.impl.portal.desktop.cosmic.service"%,
      # m%"sed -i 's|\/bin\/false|\/usr\/libexec\/xdg-desktop-portal-cosmic|g' ${DEST}/usr/share/dbus-1/services/org.freedesktop.impl.portal.desktop.cosmic.service"%,
      "cargo tree --target=x86_64-unknown-linux-musl -e features > features_manifest.txt",
    ],

    patches = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBoth,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      (drvs.findutils & { priority = 1 }),
      drvs.git,
      drvs.gnumake,
      drvs.cosmicXdgDesktopPortalSources,
      drvs.alsaLibs,
      drvs.atSpi2Core,
      drvs.bluez,
      drvs.cairo,
      drvs.cairoGobjectEmpty,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.fdkAac,
      drvs.ffmpeg,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glib,
      drvs.gperf,
      drvs.gtk3,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jansson,
      drvs.jsonC,
      drvs.kmod,
      drvs.ldacbt,
      drvs.libcamera,
      drvs.libdisplayinfo,
      drvs.libdlEgl,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfreeaptx,
      drvs.libinput,
      drvs.libjpegTurbo,
      drvs.libopus,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libsndfile,
      drvs.libusb,
      drvs.libxkbcommon,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.lua,
      drvs.m4,
      drvs.mesaExp,
      drvs.mtdev,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.sbc,
      drvs.seatd,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.pipewire,
      drvs.dinit,
      drvs.libstdcppCompat,
      drvs.elogindWithPolkit,
      drvs.libcap,
    ],
  },
}
