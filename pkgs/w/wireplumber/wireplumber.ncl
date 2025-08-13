{
  lib,
  drvs,
  wireplumber | lib.MesonPackage = {

    singleSource = {
      uri = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.10/wireplumber-0.5.10.tar.gz",
      sha256sum = "c2e021d8e6ef1db644facd4a97f5a644b67481c641da9100e851aab6752ba446"
    },

    extraMesonArgs = [
      "-Dsystem-lua=true",
      # "-Dmodules=false",
    ],

    preConfigurePhase = [
      m%"
            for f in $(find "${SRC}" -name meson.build); do
                sed -i 's@shared_library@library@g' "${f}"
            done
            "%,
    ],

    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.dbus,
      drvs.alsaLibs,
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
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.libevdev,
      (drvs.findutils & { priority = 1 }),
      drvs.libsndfile,
      drvs.pipewire,
      drvs.lua,
      drvs.libopus,
    ],
  }
}
