{
  lib,
  drvs,
  pulseaudio17 | lib.MesonPackage = {
    singleSource = {
      uri = "https://freedesktop.org/software/pulseaudio/releases/pulseaudio-17.0.tar.xz",
      sha256sum = "053794d6671a3e397d849e478a80b82a63cb9d8ca296bd35b73317bb5ceb87b5"
    },

    extraMesonArgs = [
      "-Ddoxygen=false",
      "-Ddatabase=simple",
      "-Drunning-from-build-tree=true",
    ],
    preConfigurePhase = [
      m%"
      for f in $(find ${SRC} -name meson.build); do
        sed -i 's@shared_library@library@g' ${f}
      done
      "%,
      m%"
      for f in $(find ${SRC} -name meson.build); do
        sed -i 's@shared_module@library@g' ${f}
      done
      "%,
    ],
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
      drvs.perlDynamic,
      drvs.perlXmlParserDynamic,
      drvs.m4,
      drvs.dbus,
      drvs.libcap,
      drvs.eudev,
      drvs.kmod,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      # drvs.pkgconf,
      drvs.alsaLibs,
      drvs.bluez,
      drvs.sbc,
      drvs.ffmpeg,
      drvs.speex,
      drvs.speexdsp,
      drvs.check,
    ]
  },

  pulseaudioBin =
    pulseaudio17
    & {
      postInstallPhase = [
        "rm -rf ${DEST}/etc",
        "rm -rf ${DEST}/lib",
        "rm -rf ${DEST}/usr/lib",
        "rm -rf ${DEST}/usr/include",
        "rm -rf ${DEST}/usr/bin/pulseaudio",
        "rm -rf ${DEST}/usr/share/pulseaudio",
        "rm -rf ${DEST}/usr/share/dbus-1",
        "rm -rf ${DEST}/usr/share/vala",
      ]
    }
}
