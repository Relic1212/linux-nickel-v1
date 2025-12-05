{
  lib,
  drvs,
  cava,
  date,
  waybar | lib.MesonPackage = {
    singleSource = {
      #uri = "https://github.com/Alexays/Waybar/archive/refs/tags/0.11.0.tar.gz",
      #sha256sum = "6a0e9f0f7f2eff503951958cbb16dc39041c0b67e86c35154e8507677c61be9d",

      # uri = "https://github.com/Alexays/Waybar/archive/refs/tags/0.12.0.tar.gz",
      # sha256sum = "80454a0778176f575c112bdef9107f272621b578aa629bcc257ad9844a6c7165"

      # uri = "https://github.com/Alexays/Waybar/archive/refs/tags/0.13.0.tar.gz",
      # sha256sum = "5148c802ecdcb459f0dbcb20b43a30f5751e9c1b2c9ed7bb893aa87f37212307",

      uri = "https://github.com/Alexays/Waybar/archive/refs/tags/0.14.0.tar.gz",
      sha256sum = "7f3859779bb3a5028a7215b2000c2e476c03453a52289164ba60a4bf1bb3772f"
    },

    # sourceInputs = [
    #   {
    #     src = singleSource
    #   },
    #   {
    #     src = cava.singleSource,
    #     dest ="subprojects/cava"

    #   },
    #   {
    #     src = date.singleSource,
    #     dest ="subprojects/date"
    #   }
    # ],

    llvmProvider = drvs.llvmFull,
    pythonProvider = drvs.pythonDynamic,
    useMuon,
    # useMuon = true,
    # 

    biDrvs =
      (if useMuon then [pythonProvider] else [])
      @ [
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
        drvs.cairo,
        drvs.libpng,
        drvs.harfbuzz,
        drvs.glibDynamic,
        drvs.muslShared,
        drvs.hwdata,
        drvs.gobjectDynamic,
        drvs.cairoGobject,
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
        drvs.gtkLayerShell,
        drvs.libinputFixedSyms,
        drvs.mtdev,
        drvs.eudev,
        drvs.sndiod,
        drvs.upower,
        drvs.libnl,
        drvs.dbusmenuGtk,
        drvs.catch2,
        drvs.pipewire,
        drvs.libsndfile,
        drvs.libopus,
        drvs.lua,
        drvs.bluez,
        drvs.sbc,
        drvs.libusb,
        drvs.ffmpeg,
        drvs.jansson,
        drvs.libfreeaptx,
        drvs.fdkAac,
        drvs.ldacbt,
        drvs.libyaml,
        drvs.openssl,
        drvs.alsaLibs,
        drvs.dbus,
        drvs.libmpdclient,
        drvs.playerctl,
        drvs.fftw,
        drvs.iniparser,

        # drvs.cmake,
        # drvs.cava,
        drvs.date,
        drvs.elogindWithPolkit,
        drvs.polkit,
        drvs.libcap,
      ],

    extraMesonArgs = [
      "-Dlibinput=enabled",
      "-Dlibudev=enabled",
      "-Dlibevdev=enabled",
      "-Dupower_glib=enabled",
      "-Dman-pages=enabled",
      "-Drfkill=enabled",
      "-Dsndio=enabled",
      "-Dlibnl=enabled",
      "-Ddbusmenu-gtk=enabled",
      "-Dwireplumber=enabled",
      "-Dpipewire=enabled",
      # "-Dcava=enabled",
      "-Dmpris=enabled",
      # "--force-fallback-for='cava,date'",
    ]
  }
}
