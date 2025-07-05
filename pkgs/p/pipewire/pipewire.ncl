{
  lib,
  drvs,
  _pipewire | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/pipewire/pipewire/-/archive/1.3.83/pipewire-1.3.83.tar.gz",
      sha256sum = "fb9ffee4c8cece297dd44cb83bc070d9fdf0d264a08858b21b401e17683ca790"
    },
    patches = [
      {
        sha256sum = "86cb1b6ff59ed947f8c2ad01b9c473e0a97946d6dde20b62dedf4f79385ff654",
        file = "pipewire.patch"
      }
    ],
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
    ],
    extraMesonArgs = [
      "-Dsession-managers=[]",
      "-Dvideotestsrc=disabled",
      "-Dvideoconvert=disabled",
      "-Dv4l2=disabled",
      "-Dsupport=enabled",
      "-Dspa-plugins=enabled",
      "-Dtests=disabled",
      "-Davb=disabled",
      "-Draop=disabled",
      "-Dsndfile=enabled",
    ],
    preConfigurePhase = [
      m%"
            for f in $(find "${SRC}" -name meson.build); do
                sed -i 's@shared_library@library@g' "${f}"
            done
            "%,

      # "sed -i 's@, plugin_dependencies@@g' ${SRC}/src/modules/meson.build",
    ]
  },
  pipewire | lib.MesonPackage =
    _pipewire
    & {
      mesonArgs | force = lib.functions.replaceArrayElem "--buildtype=release" "--buildtype=debug" _pipewire.mesonArgs
    }
}
