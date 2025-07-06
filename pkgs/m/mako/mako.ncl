{
  lib,
  cairo,
  expat,
  pixman,
  zlibNg,
  freetype,
  fontconfig,
  libpng,
  glib,
  pcre2,
  libffi,
  harfbuzz,
  pango,
  wayland,
  waylandProtocols,
  basu,
  linuxHeaders,

  mako | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/emersion/mako/releases/download/v1.9.0/mako-1.9.0.tar.gz",
      sha256sum = "16d821ef49acfc8503367e1a886d28b2f8578ae9ceb1a7e284888b1e32b3a337",
    },
    biDrvs =
      lib.biMap [
        cairo,
        expat,
        pixman,
        zlibNg,
        freetype,
        fontconfig,
        libpng,
        glib,
        pcre2,
        libffi,
        harfbuzz,
        pango,
        wayland,
        waylandProtocols,
        basu,
        linuxHeaders,
      ],
    extraMesonArgs = [
      "-Dzsh-completions=true",
      "-Dicons=disabled",
      "-Dman-pages=disabled"
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
