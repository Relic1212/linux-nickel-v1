{
  lib,
  drvs,
  mako | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/emersion/mako/releases/download/v1.10.0/mako-1.10.0.tar.gz",
      sha256sum = "a72543f7b92568a0c3c45a5c0e3487ced65c18003eecd9b7d017a6464e7cef82",
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
