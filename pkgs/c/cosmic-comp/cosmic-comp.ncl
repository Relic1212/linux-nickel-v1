{
  lib,
  drvs,
  distro,
  cosmicComp | lib.CargoPackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/pop-os/cosmic-comp/commit/dc983e7ee4201040e0f58fdbe96be1afcbdf7312.patch",
          sha256sum = "370435f120c904c002af256554085b788e32cd9ecc51ddec7ddb6ab0a05fc835"
        }
      },
    ],

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xvf /cosmic-comp-sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      "(cd ${SRC} && patch -p1 < ../packed/370435f120c904c002af256554085b788e32cd9ecc51ddec7ddb6ab0a05fc835/dc983e7ee4201040e0f58fdbe96be1afcbdf7312.patch)",
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
        @ (if distro.pam then ["-lcap"] else [])
        @ (
          let s = "-lEGL -lpthread -lpthread -lz -lgbm -lGLESv2 -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -ldl -lpthread -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link -ldrm_amdgpu -lelf -lz -ldrm_intel -ldrm -lpciaccess -lz -ldrm -lwayland-client -lwayland-server -lm -pthread -lrt -lffi"
          in
          std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " s)
        )
        @ [
          "-C link-arg=-Wl,--pop-state",
        ],
    },

    patches = [
      {
        file = "static-gl.patch",
        sha256sum = "87d04858cb694020f4b6e2354ef2640f4e7f1bac3c933c8b7b2f37d43d59b7b7"
      },
      {
        sha256sum = "9c4fd74ddabfbe7ce1e1cd71c728fc912659185fe5f2ec03905498badfc1afd0",
        file = "ffi.patch"
      },
      # {
      #   sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
      #   file = "cosmic-osd-xkb.patch",
      # }
    ],

    # release = false,

    # default = systemd
    extraCargoFlags = [
      "--no-default-features"
    ],

    cargoFlags,
    target,

    buildPhase = [
      "make ARGS+=\"%{std.string.join " " cargoFlags}\"",
    ],
    installPhase = [
      "make TARGET=%{target}/release DESTDIR=$DEST install",
    ],
    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features > features_manifest.txt",
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
      drvs.gnumake,
      drvs.cosmicCompSources,
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
      drvs.seatd,
      drvs.elogindWithPolkit,
      drvs.libcap,
    ],

    # propagatedBuildInputs = [
    #         drvs.seatd,

    # ],
  },

  testFetcher | lib.DeterministicFetcher = {
    buildPhase = [
      "wget https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0-beta.6.tar.gz",
      "cp epoch-1.0.0-beta.6.tar.gz ${DEST}/out.tar.gz",
    ],
    outputFile = "out.tar.gz",
    outputSha256sum = (import "src.sha256sum" as 'Text), # "7bd9f19a69fb9708448d0a551d2c8bf5abf809457694f17aefd8d4d03b70d16d",
    biDrvs = [
      drvs.emptyResolvConf
    ]
  },
  emptyResolvConf | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/etc",
      "touch ${DEST}/etc/resolv.conf",
    ]
  }
}
& {
  lib,
  drvs,
  _cosmicSrcSha256sums,
  cosmicCompSources | lib.DeterministicFetcher = {
    singleSource = {
      uri = "https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0-beta.6.tar.gz",
      sha256sum = _cosmicSrcSha256sums."%{uri}",
    },
    extraEnv = {
      HOME = "/tmp/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      "cargo vendor --locked >> .cargo/config.toml",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "3ae4cb26d9fff4c7154b68bcbfedb84b9cc14cf5b85bfec71bd4239ef22bedcf",
    outputSha256sum = (import "src.sha256sum" as 'Text), # "163454290382acc2c491376355c67f93cdb72e1a2fe2056f21c0d4a41f8a1821",

    outputFile = "cosmic-comp-sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      # drsv.gnutar & {priority = 1},
    ]
  }
}
& {
  lib,
  drvs,
  _CargoFetcher | lib.DeterministicFetcher = {

    extraEnv = {
      HOME = "/tmp/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      "cargo vendor --locked >> .cargo/config.toml",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "3ae4cb26d9fff4c7154b68bcbfedb84b9cc14cf5b85bfec71bd4239ef22bedcf",
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "163454290382acc2c491376355c67f93cdb72e1a2fe2056f21c0d4a41f8a1821",

    outputFile = "sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      # drsv.gnutar & {priority = 1},
    ]
  }
}
& (
# import "../cosmic-common/cosmic-src.ncl"
{ _cosmicSrcSha256sums = import "../cosmic-common/_cosmic_sources.ncl" }
)
