{
  lib,
  drvs,
  squeekboard | lib.CargoPackage =
    let _preConfigurePhase = [
      "sed -i 's@-Werror=implicit-fallthrough=3@-Werror=implicit-fallthrough@g' ${SRC}/meson.build",
      "sed -i 's@-Werror=maybe-uninitialized@-Werror=uninitialized@g' ${SRC}/meson.build",
      "sed -i 's@-Wmaybe-uninitialized@-Wuninitialized@g' ${SRC}/meson.build",
      m%"sed -i "s@\'--release\'@\'--release\',\'--offline\',\'--target\', \'x86_64-unknown-linux-musl\', \'--verbose\'@g" ${SRC}/meson.build"%,
      m%"sed -i 's@\.\/@\.\/x86_64-unknown-linux-musl\/@g' ${SRC}/cargo_build.py"%,
    ]
    in
    {
      singleSource = {
        uri = "https://gitlab.gnome.org/World/Phosh/squeekboard/-/archive/v1.43.1/squeekboard-v1.43.1.tar.gz",
        sha256sum = "64c73636f6d8a6ffe9f1094c4084b184db3f60ac4e02bf8bff860060308c61ab"
      },
      crates = lib.functions.filterCrates (import "./squeekboard-crates.json"),

      llvmProvider = drvs.llvmFull,
      biDrvs = [
        drvs.fontconfig,
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.pixman,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.libxkbcommon,
        drvs.expat,
        drvs.linuxHeaders,
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2,
        drvs.pango,
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glibPatched,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.libjpegTurboStatic,
        drvs.libepoxy,
        drvs.atSpi2Core,
        drvs.mesa2,
        drvs.libelf,
        drvs.libdrm,
        drvs.libpciaccess,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.gtk3,
        drvs.eudev,
        drvs.kmod,
        drvs.xz,
        drvs.openssl,
        drvs.zstd,
        drvs.utilLinux,
        drvs.gsettingsDesktopSchemas,
        drvs.xkeyboardConfig,
        drvs.isoCodes,
        drvs.libseccomp,
        drvs.gnomeDesktop,
        drvs.meson,
        drvs.pythonFull,
        drvs.samurai,
        drvs.musl,
        drvs.gettext,
        drvs.libbsd,
        drvs.libmd,
        drvs.feedbackd,
        drvs.libvorbis,
        drvs.libogg,
        drvs.libcanberra,
        drvs.gsound,
      ],

      configurePhase =
        _preConfigurePhase
        @ [
          "cd  /tmp/workdir/build",
          m%"meson setup --prefix=/usr \
        --buildtype=release \
        --bindir=bin \
        --sbindir=bin \
        --datadir=share \
        --libdir=lib \
        --libexecdir=libexec \
        --includedir=include \
        --mandir=share/man \
        --infodir=share/info \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --sharedstatedir=/com \
        --wrap-mode=nodownload \
        --prefer-static \
        -Ddefault_library=static \
        . ${SRC}
        "%
        ],
      buildPhase = [
        "meson compile",
      ],
      installPhase = [
        "meson install --destdir ${DEST}",
      ],

      buildEnv = {
        EXTRA_LDFLAGS = [
          "-lepoxy",
          "-lwayland-client",
          "$(pkg-config --libs --static gdk-wayland-3.0 gdk-3.0)",
        ],
      },
      extraEnv = {
        EXTRA_RUSTFLAGS =
          [
            #"-C link-arg=-lepoxy",
            #"-C link-arg=-lepoxy",
            #"-C link-arg=-lwayland-client",
            #"-C link-arg=-lfribidi",
            " "
          ]
          @ (
            std.string.split
              " "
              "-lwayland-cursor -lwayland-egl -lwayland-client -lwayland-server -lffi -lfribidi -lepoxy -lEGL -lpthread -lgbm -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMDebugInfoCodeView -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -lrt -ldl -lpthread -ldrm_radeon -ldrm_amdgpu -lelf -lz -ldrm_intel -lpciaccess -lGLESv2 -pthread -lm -lpthread -lz -ldrm"
          )
          |> std.array.map (fun x => "-C link-arg=" ++ x)
      }
    }
}
