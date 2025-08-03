 


{
  lib,
  drvs,

    _kbvm_crate = {
      "0.1.4" | lib.Crate = {
        name = "kbvm",
        version = "0.1.4",
        sha256sum = "474d0a1323fee9226a308be0ff72f1f699f1094a6ba3fc6c1495056bffa0dbbc",
        # sourceInput = {
        #   dest | priority 1 = ""
        # }
      },
    },

  alacritty | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/alacritty/alacritty/archive/refs/tags/v0.15.1.tar.gz",
      sha256sum = "b814e30c6271ae23158c66e0e2377c3600bb24041fa382a36e81be564eeb2e36",
      #uri = "https://github.com/alacritty/alacritty/archive/9eb68039dcb3edf9c87d253532a3ddd6c3cb8c4e.tar.gz",
      #sha256sum = "3aabf3d88a7ad13b45542588e069e9a7f5f23dfd5d692bc2df394712ca4e7cac"
    },

    nonCrateSourceInputs = [
        { src = singleSource},
        {
        src = {
            #uri ="https://github.com/mahkoh/winit/archive/851b2218b8b68961443f11bad6a9f24bcc68f013.tar.gz",
            #sha256sum = "0eb6a1e96c0cc5f1cfff2a80de2fb574bb1532a795949d3a853e20af663b561a",

            #uri = "https://github.com/zuckschwerdt/winit/archive/513604e0cb15da96e6d3c76b4afc5148b1a8f873.tar.gz",
            #sha256sum = "869c86f75619730c56a22bfa9c73e579b648bebb8033120a49797fa4e611d239",


            uri = "https://github.com/rust-windowing/winit/archive/58402b58cf660e236e825b36287a8fc2abfb1f5d.tar.gz",
            sha256sum = "f53ca2163ab21fe746b4697c18438453b2563e3dc94358a259abd78c047af567",
        },
        dest ="vendor-winit",
    }],
    crates = (lib.functions.filterCrates (import "alacritty-crates.json")) & 
    { kbvm = _kbvm_crate} &
    (lib.functions.filterCrates (import "kbvm-crates.json")) 
    # &(lib.functions.filterCrates (import "winit-kbvm-crates.json"))
    # &(lib.functions.filterCrates (import "winit-dpi-crates.json"))

    ,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommonWithRegistry,
      drvs.libxml2,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.cairo,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
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
      drvs.libsigcpp2,
      drvs.cairomm_1_0,
      drvs.pangomm,
      drvs.glibmm,
      drvs.pythonSetuptools,
      drvs.gtkmm3,
      drvs.fmt,
      drvs.spdlog,
      drvs.libevdev,
      drvs.jsoncpp,
      drvs.scdoc,
      drvs.libinputFixedSyms,
      drvs.epollShim,
      drvs.mtdev,
      drvs.eudev,
    ],

    extraCargoFlags = [
      "--no-default-features",
      "--features=wayland",
      "--verbose",
    ],
    extraEnv = {
        EXTRA_RUSTFLAGS = ["-v"]
    },

    configurePhase = [


        #  "(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/851b2218b8b68961443f11bad6a9f24bcc68f013.patch)",
         #"(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/0001-https-github.com-rust-windowing-winit-pull-4086.patch)",

        "rm -rf ${SRC}/vendor/winit-*",
        "mv ${SRC}/vendor-winit ${SRC}/vendor/winit-0.30.9",
        "(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/513604e0cb15da96e6d3c76b4afc5148b1a8f873.patch)",


        m%"echo '{"package":"'"a809eacf18c8eca8b6635091543f02a5a06ddf3dad846398795460e6e0ae3cc0"'","files":{}}' >  ${SRC}/vendor/winit-0.30.9/.cargo-checksum.json"%,


        #"rm -rf ${SRC}/vendor/dpi-0.1.1",
        #"cp -r ${SRC}/vendor/winit-0.30.9/dpi ${SRC}/vendor/dpi-0.1.1",

        #m%"echo '{"package":"'"f25c0e292a7ca6d6498557ff1df68f32c99850012b6ea401cf8daf771f22ff53"'","files":{}}' >  ${SRC}/vendor/winit-0.30.9/.cargo-checksum.json"%,

        #"sed -i 's@edition.workspace = true@@g' ${SRC}/vendor/dpi-0.1.1/Cargo.toml",


        m%"
        sed -i \
            's@"wayland-dlopen",@@g' \
            ${SRC}/vendor/winit-*/Cargo.toml
        "%,
        m%"
        sed -i \
            's@"x11",@"serde",@g' \
            ${SRC}/vendor/winit-*/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"x11-dlopen",@@g' \
            ${SRC}/vendor/winit-*/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"xkbcommon-dl/x11",@@g' \
            ${SRC}/vendor/winit-*/Cargo.toml
        "%,


          m%"
        sed -i \
            's@0.30.8@0.30.9@g' \
            ${SRC}/vendor/winit-*/Cargo.toml
        "%,

        m%"
        sed -i \
            's@"std"@"std","serde"@g' \
            ${SRC}/vendor/winit-*/dpi/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"winit/wayland-dlopen",@@g' \
            ${SRC}/alacritty/Cargo.toml
        "%,

        # m%"
        # sed -i \
        #     's@"rwh_06",@@g' \
        #     ${SRC}/alacritty/Cargo.toml
        # "%,




        # m%"
        # sed -i \
        #     's@objc2 = "0.5.2"@objc2 = "0.6.1"@g' \
        #     ${SRC}/alacritty/Cargo.toml
        # "%,

        m%"
        sed -i \
            's@"dlopen"@@g' \
            ${SRC}/vendor/smithay-clipboard-*/Cargo.toml
        "%,
        
        m%"
        sed -i \
            's@"dlopen",@@g' \
            ${SRC}/vendor/glutin-*/Cargo.toml
        "%,
        
    ],
    release = false,

    patches = [{

    # file = "851b2218b8b68961443f11bad6a9f24bcc68f013.patch",
    # sha256sum = "e20b9d6c40683943740ea69a2737c0ffaa8522f4bb1e9ff0cc8fc797cd720f83",
    # file =   "0001-https-github.com-rust-windowing-winit-pull-4086.patch",
    # sha256sum = "f2f0a9eafff40c32665f8ed1334385b7f81ae52434ef956ef366d41ce843d6ac",

       file = "513604e0cb15da96e6d3c76b4afc5148b1a8f873.patch",
       sha256sum = "ca62a08327c426ae8d16796e8ab6add94d9d9bab9507f4b8d8a7320baad6aff5",
    }],
    patchPhase = [],

    
  }
}
