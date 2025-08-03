 


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
      sha256sum = "b814e30c6271ae23158c66e0e2377c3600bb24041fa382a36e81be564eeb2e36"
    },
    crates = (lib.functions.filterCrates (import "alacritty-crates.json")) & 
    { kbvm = _kbvm_crate} &
    (lib.functions.filterCrates (import "kbvm-crates.json"))
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
    ],

    configurePhase = [


        #  "(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/851b2218b8b68961443f11bad6a9f24bcc68f013.patch)",
         "(cd ${SRC}/vendor/winit-0.30.9 && patch -p1 < /tmp/workdir/patches/0001-https-github.com-rust-windowing-winit-pull-4086.patch)",



        m%"
        sed -i \
            's@"wayland-dlopen",@@g' \
            ${SRC}/vendor/winit-0.30.9/Cargo.toml
        "%,
        m%"
        sed -i \
            's@"x11",@@g' \
            ${SRC}/vendor/winit-0.30.9/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"x11-dlopen",@@g' \
            ${SRC}/vendor/winit-0.30.9/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"xkbcommon-dl/x11",@@g' \
            ${SRC}/vendor/winit-0.30.9/Cargo.toml
        "%,


        m%"
        sed -i \
            's@"winit/wayland-dlopen",@@g' \
            ${SRC}/alacritty/Cargo.toml
        "%,

        m%"
        sed -i \
            's@"dlopen"@@g' \
            ${SRC}/vendor/smithay-clipboard-0.7.2/Cargo.toml
        "%,
        
        m%"
        sed -i \
            's@"dlopen",@@g' \
            ${SRC}/vendor/glutin-0.32.2/Cargo.toml
        "%,
        
    ],

    patches = [{

        # file = "851b2218b8b68961443f11bad6a9f24bcc68f013.patch",

        # sha256sum = "e20b9d6c40683943740ea69a2737c0ffaa8522f4bb1e9ff0cc8fc797cd720f83",

        file =   "0001-https-github.com-rust-windowing-winit-pull-4086.patch",

        sha256sum = "f2f0a9eafff40c32665f8ed1334385b7f81ae52434ef956ef366d41ce843d6ac",
    }],
    patchPhase = [],

    
  }
}
