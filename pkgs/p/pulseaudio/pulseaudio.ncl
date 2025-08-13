{
  lib,
  drvs,
  pulseaudio14 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.gz",
      sha256sum = "902dd1928801bb5dc7b121754aa4110ce55768b5dff94a700e7bd58d3f597970"
    },

    #llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.libsndfile,
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
      #drvs.mesa2,
      #drvs.libelf,
      #drvs.libdrm,
      #drvs.libpciaccess,
      #drvs.llvmConfigStatic,
      #drvs.spirvTools,
      #drvs.spirvLlvmTranslator,

      #drvs.gtk3,
      drvs.libtool,
      drvs.perl,
      drvs.m4,
      drvs.dbus,
      drvs.libcap,
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.pkgconf,
      drvs.alsaLibs,
      drvs.bluez,
      drvs.sbc,
      drvs.ffmpeg,
      drvs.speex,
      drvs.speexdsp,
    ],

    preConfigurePhase = [
      "sed -i 's@main ()@main (void)@g' ${SRC}/configure",
      "sed -i 's@#include <gdk/gdkx.h>@@g' ${SRC}/src/pulsecore/proplist-util.c",

      #  "sed -i 's@#ifdef DISABLE_LIBTOOL_PRELOAD@#if 1@g' ${SRC}/src/daemon/main.c",
      "sed -i 's@#ifdef PA_BIND_NOW@#if 0@g' ${SRC}/src/daemon/ltdl-bind-now.c",
    ],
    extraConfigureFlags = [
      "--enable-static-bins",
      "--enable-force-preopen",
      "--disable-gtk3",
      "--enable-bluez5",
      "--with-speex",
      "ac_cv_func_dlopen='no'"
    ],
    postInstallPhase = [
      "cd ${DEST}/usr/lib/pulse-14.2/modules/",
      m%"
            for f in $(ls); do
                new_name=$(echo ${f} | cut -d '.' -f1)
                new_name="${new_name}.so"
                ln -s ${f} ${new_name}
            done
            "%
    ]
  }
}
& {
  lib,
  drvs,
  pulseaudio14,
  pulseaudio8 = (
    pulseaudio14
    & {
      singleSource | priority 200 = {
        uri = "https://freedesktop.org/software/pulseaudio/releases/polypaudio-0.8.1.tar.gz",
        sha256sum = "6425fc9bc3a260b20506ae3e7397308af963f547f1a09b4dd85e1b2525b674e9"
      },
      preConfigurePhase | priority 1 = [],
      biDrvs | priority 1 =
        pulseaudio14.biDrvs
        @ [
          drvs.libsamplerate,
          drvs.liboil,
        ],
      extraConfigureFlags | priority 1 = [
        "--enable-static-bins",
        "--enable-force-preopen",
        "--disable-gtk3",
        "--enable-bluez5",
        "--with-speex",
        "ac_cv_func_dlopen='no'",
        "ac_cv_func_memcpy='no'",
      ]
    }
  )
}
& (import "./pulseaudio-lennart.ncl")
& (import "./pulseaudio17.ncl")
