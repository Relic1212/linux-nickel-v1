{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcs,
  cosmicSessionSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicSrcs."cosmic-session",

      outputSha256sum = (import "src.sha256sum" as 'Text), # "97d29b368657b5d2bd4a3634d9914780a55721e8e5ce95e227b6432d9ccd8337"
    },
}
& {
  lib,
  drvs,
  cosmicSession | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
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
        ]
        @ (
          let s = "-lEGL -lpthread -lpthread -lz -lgbm -lGLESv2 -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -ldl -lpthread -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link -ldrm_amdgpu -lelf -lz -ldrm_intel -ldrm -lpciaccess -lz -ldrm -lwayland-client -lwayland-server -lm -pthread -lrt -lffi"
          in
          std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " s)
        )
        @ [
          "-C link-arg=-Wl,--pop-state",
        ],

      XDP_COSMIC = "'/usr/libexec/xdg-desktop-portal-cosmic'",
    },

    eofPatches = [
      {
        patch = import "fix-auto.patch" as 'Text
      }
    ],
    extraCargoFlags = [
      "--no-default-features",
      "--features \"autostart logind-zbus\"",
    ],
    target,
    release,
    installPhase =
      (
        if (!release) then
          [
            "sed -i 's@release/cosmic-session@debug/cosmic-session@g' ${SRC}/Justfile"
          ]
        else
          []
      )
      @ [
        "export CARGO_TARGET_DIR=\"target/%{target}\"",
        "just rootdir=$DEST install",
      ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
      m%"sed -i 's|/bin/bash|/usr/bin/bash|g' ${DEST}/usr/bin/start-cosmic"%,

      # https://wiki.nixos.org/wiki/COSMIC#Clipboard
      # m%"sed -i "s|export DCONF_PROFILE=/usr/share/dconf/profile/cosmic|export DCONF_PROFILE=/usr/share/dconf/profile/cosmic\nexport COSMIC_DATA_CONTROL_ENABLED=1|g" ${DEST}/usr/bin/start-cosmic"%,
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
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    enableSccache = true,
    biDrvs = [
      drvs.just,
      drvs.cosmicSessionSources,
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
      drvs.libstdcppCompat,
    ],
  },
}
