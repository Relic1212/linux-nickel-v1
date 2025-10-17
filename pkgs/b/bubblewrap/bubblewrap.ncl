{
  lib,
  drvs,
  bubblewrap | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz",
      sha256sum = "988fd6b232dafa04b8b8198723efeaccdb3c6aa9c1c7936219d5791a8b7a8646",
    },

    extraMesonArgs = [
      "-Dbash_completion=disabled",
      "-Dzsh_completion=enabled",
      "-Dtests=false",
      "-Dman=enabled",
    ],

    preConfigurePhase = [
      m%"sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${SRC}/meson.build"%,
      m%"
      for f in $(find ${SRC} -type f -name '*.xml' ); do
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
      done
      "%,
    ],
    biDrvs = [
      drvs.libcap,
      # drvs.zsh,
      drvs.linuxHeaders,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
    ],
  }
}
