{
  lib,
  drvs,
  mako | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/emersion/mako/releases/download/v1.11.0/mako-1.11.0.tar.gz",
      sha256sum = "e97eb5bd0dc6a9159019949f48b3db4e8781b56bd6377bd65827e1cb440a7def",
    },
    biDrvs = [
      drvs.cairo,
      drvs.expat,
      drvs.pixman,
      drvs.zlibNg,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.glib,
      drvs.pcre2,
      drvs.libffi,
      drvs.harfbuzz,
      drvs.pango,
      drvs.fribidi,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.basu,
      drvs.linuxHeaders,
      drvs.libjpegTurbo,
      drvs.gdkPixbufFull,
      drvs.scdoc,
    ],

    buildEnv = {
      EXTRA_CFLAGS = [
        "-Wno-error=unused-but-set-global",
        # "-Werror,-Wunused-but-set-global",
      ],
    },

    extraMesonArgs = [
      "-Dzsh-completions=true",
      "-Dicons=enabled",
      "-Dman-pages=enabled"
    ],
    preConfigurePhase = [
      m%"
            fix_symbol(){
                for f in $(find ${SRC} -type f);do
                    sed -i "s@${1}(@${1}_mako_reserved(@g" $f
                    sed -i "s@_${1}_mako_reserved(@_${1}(@g" $f
                done
            }

            fix_symbol "parse_boolean"
            "%
    ]
  }
}
