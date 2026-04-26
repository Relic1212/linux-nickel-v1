{
  lib,
  drvs,
  distro,
  libdlEgl,
  niri | lib.CargoPackage = {
    buildEnv = {
      # EXTRA_LDFLAGS = ["-lc++",
      # #  "-lEGL",
      #   # "-lgallium_dri"
      #   ],
      # EXTRA_CFLAGS = EXTRA_LDFLAGS, # ["-lc++","-lEGL"],
      LLVM_LDFLAGS | priority 1 = ["-fuse-ld='lld -lEGL -lgallium_dri'", "-stdlib=libc++", "-rtlib=compiler-rt", "-unwindlib=libunwind"],
      # LD | priority 1 = "\"lld --verbose -lEGL -lgallium_dri\"",
      CC = "cc",
    },
    options = {
      glx | default = false,
    },
    extraEnv = {
      # https://github.com/NixOS/nixpkgs/pull/264517#issuecomment-1817817060
      EXTRA_RUSTFLAGS =
        [

          # "-C link-arg=-L/usr/lib",
          "-C link-arg=-Wl,--push-state,--no-as-needed",
          "-C link-arg=/tmp/workdir/src/dlopen.o",

          # "-C link-arg=-lEGL",
          # "-C link-arg=-lwayland-client",
          # "-C link-arg=-Wl,--pop-state",
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
          if distro.pam then ["-lcap"] else []
        )
        @ (
          let s = "-lEGL -lpthread -lpthread -lz -lgbm -lGLESv2 -lgallium_dri -lLLVMWindowsDriver -lLLVMFrontendHLSL -lLLVMFrontendDriver -lLLVMX86TargetMCA -lLLVMX86Disassembler -lLLVMX86AsmParser -lLLVMX86CodeGen -lLLVMX86Desc -lLLVMX86Info -lLLVMMCJIT -lLLVMLTO -lLLVMExtensions -lLLVMLibDriver -lLLVMOption -lLLVMInterpreter -lLLVMExecutionEngine -lLLVMRuntimeDyld -lLLVMOrcTargetProcess -lLLVMOrcShared -lLLVMCoverage -lLLVMAMDGPUTargetMCA -lLLVMMCA -lLLVMAMDGPUDisassembler -lLLVMMCDisassembler -lLLVMAMDGPUAsmParser -lLLVMAMDGPUCodeGen -lLLVMPasses -lLLVMCoroutines -lLLVMCFGuard -lLLVMMIRParser -lLLVMIRPrinter -lLLVMipo -lLLVMInstrumentation -lLLVMVectorize -lLLVMSandboxIR -lLLVMLinker -lLLVMFrontendOpenMP -lLLVMFrontendAtomic -lLLVMFrontendOffloading -lLLVMHipStdPar -lLLVMGlobalISel -lLLVMSelectionDAG -lLLVMAsmPrinter -lLLVMCodeGen -lLLVMTarget -lLLVMScalarOpts -lLLVMInstCombine -lLLVMAggressiveInstCombine -lLLVMObjCARCOpts -lLLVMTransformUtils -lLLVMCGData -lLLVMBitWriter -lLLVMAMDGPUDesc -lLLVMAMDGPUUtils -lLLVMCodeGenTypes -lLLVMAnalysis -lLLVMProfileData -lLLVMSymbolize -lLLVMDebugInfoBTF -lLLVMDebugInfoPDB -lLLVMDebugInfoMSF -lLLVMDebugInfoCodeView -lLLVMDebugInfoDWARF -lLLVMObject -lLLVMTextAPI -lLLVMMCParser -lLLVMIRReader -lLLVMAsmParser -lLLVMBitReader -lLLVMCore -lLLVMRemarks -lLLVMBitstreamReader -lLLVMAMDGPUInfo -lLLVMMC -lLLVMBinaryFormat -lLLVMTargetParser -lLLVMSupport -lLLVMDemangle -ldl -lpthread -lSPIRV-Tools-opt -lSPIRV-Tools -lSPIRV-Tools-link -ldrm_amdgpu -lelf -lz -ldrm_intel -ldrm -lpciaccess -lz -ldrm -lwayland-client -lwayland-server -lm -pthread -lrt -lffi"
          in
          std.array.map (fun a => "-C link-arg=%{a}") (std.string.split " " s)
        )
        @ (
          if (options.glx) then
            [
              "$(pkg-config --libs --static xcb)",
              "$(pkg-config --libs --static xcb-shm x11 x11-xcb)",
            ]
          else
            []
        )
        @ [
          "-C link-arg=-Wl,--pop-state",
        ],
    },
    enableSccache = true,
    extraCargoFlags = [
      "--no-default-features",
      # "--verbose",
      "--features dbus,dinit,pipewire",
    ],
    nonCrateSourceInputs = [
      {

        src = {

          uri = "https://github.com/niri-wm/niri/archive/refs/tags/v26.04.tar.gz",
          sha256sum = "134c602d8e0d53413a52d6cd58f9ce7e79a07d03288ee0a51ba1abd5db1b1ad9",
        }
      },
      {
        dest = "vendor",

        src = {

          uri = "https://github.com/niri-wm/niri/releases/download/v26.04/niri-26.04-vendored-dependencies.tar.xz",
          sha256sum = "407c525cd78710e72455c48741756857ca47dc32910a42f82cd40992a34beed6",
        }
      },
    ],

    patches = [
      # {
      #   sha256sum = "11634f1609a70cd9168c0ae918f7becfb0f45c462ce4af78287d56c864708f58",
      #   file = "no-dl.patch",
      # },
      # {
      #   sha256sum = "d8cb860ebd9aa63b3b9318f03c7021b73950c70a502d8fc02d4faea2e602f3ed",
      #   file = "ffi.patch"
      # },
      {
        sha256sum = "57f51f86fe9a3e653626d567d5b050dd213e85c32bbda39fb0aca22cf0ac88b5",
        file = "niri-25.11-no-winit.patch"
      }
    ],

    unpackPhase = [
      "(cd /tmp/workdir/src; tar -xf $(find /tmp/workdir/packed -name 'v*.tar.gz') --strip-components=1)",
      "mkdir /tmp/workdir/src/vendor -p",
      "(cd /tmp/workdir/src/vendor; tar -xf $(find /tmp/workdir/packed -name 'niri-*-vendored-dependencies.tar.xz') --strip-components=1)",
      # "(cd /tmp/workdir/src/vendor-winit; tar -xf $(find /tmp/workdir/packed -name '58402b58cf660e236e825b36287a8fc2abfb1f5d.tar.gz') --strip-components=1)",
    ],

    configurePhase = [
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
      "echo '%{import "../../n/niri/niri_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",

      # checksum removal from Alpine
      #m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      #m%"sed -i 's@"x11",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"
      echo '
      [source.crates-io]
      replace-with = "vendored-sources"

      [source."git+https://github.com/Smithay/smithay.git?rev=ff5fa7df392cecfba049ffed55cdaa4e98a8e7ef"]
      git = "https://github.com/Smithay/smithay.git"
      rev = "ff5fa7df392cecfba049ffed55cdaa4e98a8e7ef"
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "vendor"
      ' > ${SRC}/.cargo/config.toml
      "%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay/.cargo-checksum.json"%,
      # sct
      # m%"
      # sed -i \
      #   's@"xkbcommon",@@g' \
      #   ${SRC}/vendor/smithay-client-toolkit/Cargo.toml
      # "%, # echo "
      # [target.'cfg(all(unix))'.dependencies.xkbcommon]
      # version = \"0.8.0\"

      # " >> ${SRC}/vendor/winit/Cargo.toml
      # "%,

      # winit checksum
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/winit/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/smithay-client-toolkit/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/libloading/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/libspa-sys/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/pipewire-sys/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/clang-sys/.cargo-checksum.json"%,
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/bindgen/.cargo-checksum.json"%,

      # "rm -rf vendor/x11-dl",
      m%"
      echo '
      fn main() {
        println!("cargo:rustc-link-lib=static=EGL");
        println!("cargo:rustc-link-lib=static=gallium_dri"); 
        println!("cargo:rustc-link-lib=static=wayland-server"); 
        println!("cargo:rustc-link-lib=static=wayland-client");
        println!("cargo:rustc-link-search=native=/usr/lib");

      }
      ' > ${SRC}/build.rs
      "%,
      m%"
      echo '
      #[link(name="EGL",kind="static")]
      #[link(name="gallium_dri",kind="static")]
      #[link(name="GLESv2",kind="static")]
      #[link(name="gbm",kind="static")]
      extern {}
      ' >> ${SRC}/src/main.rs
      "%,
      m%"
      echo '
      #[link(name="EGL",kind="static")]
      #[link(name="gallium_dri",kind="static")]
      #[link(name="GLESv2",kind="static")]
      #[link(name="gbm",kind="static")]
      extern {}
      ' >> ${SRC}/src/niri.rs
      "%,
      m%"sed -i 's@"backend_winit",@@g' ${SRC}/Cargo.toml"%,
      m%"sed -i 's@"winit",@@g' ${SRC}/Cargo.toml"%,
      "rm -rf ${SRC}/src/backend/winit.rs",
      "rm -rf ${SRC}/vendor/winit*",
      m%"sed -i 's@"backend_winit",@@g' ${SRC}/vendor/smithay/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/smithay/Cargo.toml"%,
      #
      # m%"sed -i 's@GlobalGenerator@StaticGenerator@g' ${SRC}/vendor/smithay/build.rs"%,
      # m%"sed -i 's@StructGenerator@StaticStructGenerator@g' ${SRC}/vendor/smithay/build.rs"%,
      #

      # m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      # m%"sed -i 's@"x11-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      # m%"sed -i 's@"renderer_multi",@@g' ${SRC}/Cargo.toml"%,
      # m%"sed -i 's@"renderer_pixman",@@g' ${SRC}/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen/Cargo.toml"%,

      #

      #
    ],

    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -d -m0755 ${DEST}/usr/share/wayland-sessions",
      "install -d -m0755 ${DEST}/usr/share/xdg-desktop-portal",
      "install -d -m0755 ${DEST}/usr/lib/dinit.d/user",
      "install -m0755 ${SRC}/target/x86_64-unknown-linux-musl/release/niri ${DEST}/usr/bin",
      "install -m0755 ${SRC}/resources/niri-session ${DEST}/usr/bin",
      "install -m0755 ${SRC}/resources/niri.desktop ${DEST}/usr/share/wayland-sessions",
      "install -m0755 ${SRC}/resources/niri-portals.conf ${DEST}/usr/share/xdg-desktop-portal",
      "install -m0755 ${SRC}/resources/dinit/niri ${DEST}/usr/lib/dinit.d/user",
      "install -m0755 ${SRC}/resources/dinit/niri.target ${DEST}/usr/lib/dinit.d/user",
    ],

    # release = false,

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBothWeakDl,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
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
        # drvs.gtk3,
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
        # drvs.libepoxy,
        drvs.libevdev,
        drvs.libffi,
        # drvs.libfreeaptx,
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
        drvs.mtdev,
        drvs.ncurses,
        drvs.openssl,
        drvs.pango,
        drvs.pcre2,
        drvs.pixman,
        drvs.readline,
        drvs.sbc,
        # drvs.seatd,
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
      ]
      @ (
        if options.glx then
          [
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
            # drvs.xwayland,
            drvs.libxkbfile,
            drvs.xcbUtilWm,
            drvs.xcbUtilErrors,
            drvs.libxext,
            drvs.libxf86vm,
            drvs.libxrandr,
            drvs.mesaGlx,
          ]
        else
          [
            drvs.mesaExp,
          ]
      ),
    propagatedBuildInputs = [
      drvs.seatd,
    ]
  },
}
& {
  lib,
  cairoGobjectEmpty | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s cairo.pc cairo-gobject.pc",
    ]
  }
}
& (import "libdl-egl.ncl")
