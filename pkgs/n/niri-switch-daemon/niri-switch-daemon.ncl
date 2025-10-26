{
  lib,
  drvs,

  niriSwitchDaemon | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/Kiki-Bouba-Team/niri-switch/archive/refs/tags/v0.2.1.tar.gz",
      sha256sum = "83e51588fc3e6251d7f58fd986dfa6e63e89cc29be54eaf50cd484f3cb50259e"
    },
    crates = lib.functions.filterCrates (import "./niri-switch-daemon-crates.json"),

    extraEnv = {
      RUSTC_BOOTSTRAP = "1",
    },

    llvmProvider = drvs.llvmFull,
    #   pythonProvider = drvs.pythonDynamic,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.waylandGtk4LayerShell,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      #drvs.pango, #??
      drvs.pango_1_56,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzzFull,
      drvs.glibDynamic,
      #   drvs.muslShared,
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
      drvs.gtk4,
      drvs.vala,
      drvs.pythonSetuptools,
      drvs.libtiff,
      drvs.graphene,
      drvs.gtkmm4,
      drvs.libsigcpp,
      drvs.cairomm_1_16,
      drvs.pangomm_2_48,
      drvs.glibmm_2_82,
      drvs.gtk4LayerShell,
    ],
  }
}
