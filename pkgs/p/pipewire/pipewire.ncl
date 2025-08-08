{
  lib,
  drvs,
  _pipewire | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.3.83/pipewire-1.3.83.tar.gz",
      # sha256sum = "fb9ffee4c8cece297dd44cb83bc070d9fdf0d264a08858b21b401e17683ca790",

      # 1.4.7
      # uri = "https://gitlab.freedesktop.org/pipewire/pipewire.git",
      # sha256sum = "1c542e9a0ca4226c9befb08fe9c19170aca3ce95",

      uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.4.7/pipewire-1.4.7.tar.gz",
      sha256sum = "9d54f025e1e7ae73b980a6c8be2e8e6387e24d554d58478d6495734ce1ee5a93"
      # uri = "/run/data/user/Projects/pipewire-static-playground.tar.gz",
      # sha256sum = "07b0d9f39a4ec30f87b0a33d8a42b177e3ba9e5ccc0ed29cd788a274658fe14c"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.10/wireplumber-0.5.10.tar.gz",
          sha256sum = "c2e021d8e6ef1db644facd4a97f5a644b67481c641da9100e851aab6752ba446"
        },
        dest = "subprojects/wireplumber"
      }
    ],

    patches = [
      {
        file = "pipewire.patch",
        sha256sum = "7cda51f444a144d8cc081574bef728a4119dac30c189690de6d2f73ed0f904aa"
      },
      {
        file = "wireplumber.patch",
        sha256sum = "3adcb61bc49928e58ce176cbc545e39ac64481a982db1d86d6b3a230bcb54810"
      }
    ],
    patchPhase = [
      "(cd ${SRC} && patch -p1 < /tmp/workdir/patches/pipewire.patch)",
      "(cd ${SRC}/subprojects/wireplumber && patch -p1 < /tmp/workdir/patches/wireplumber.patch)",
    ],
    # https://github.com/kiss-community/community/blob/0715e574d128e1df6137f3959bacc9c66fffcb18/community/pipewire/build
    extraMesonArgs = [
      "-Dsession-managers=wireplumber",
      # "-Dsession-managers=[]",
      "-Dvideotestsrc=disabled",
      "-Dvideoconvert=disabled",
      # "-Dv4l2=disabled",
      "-Dsupport=enabled",
      "-Dspa-plugins=enabled",
      "-Dtests=disabled",
      # "-Davb=disabled",
      # "-Draop=disabled",
      "-Dsndfile=enabled",
      "-Dudev=enabled",
      "-Dwireplumber:system-lua=true",
      "-Dwireplumber:tests=false",
    ],
    preConfigurePhase = [
      # m%"
      # for f in $(find "${SRC}" -name meson.build); do
      #   sed -i 's@shared_library@library@g' "${f}"
      # done
      # "%,

      # "sed -i 's@, plugin_dependencies@@g' ${SRC}/src/modules/meson.build",
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
      drvs.libopus,
      drvs.lua,
    ],
  },
  pipewire | lib.MesonPackage =
    _pipewire
    & {
      mesonArgs | force = lib.functions.replaceArrayElem "--buildtype=release" "--buildtype=debug" _pipewire.mesonArgs
    }
}
