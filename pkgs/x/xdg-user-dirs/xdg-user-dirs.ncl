{
  lib,
  drvs,
  xdgUserDirs | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://user-dirs.freedesktop.org/releases/xdg-user-dirs-0.18.tar.gz",
      sha256sum = "ec6f06d7495cdba37a732039f9b5e1578bcb296576fde0da40edb2f52220df3c"
    },

    preConfigurePhase = [
      m%"
            for f in $(find ${SRC}/man -type f -name 'Makefile*'); do
                sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${f}
            done
            "%
    ],
    biDrvs = [
      drvs.libxslt,
      drvs.xmlto,
      drvs.bash,
      drvs.libxml2,
      drvs.docbookXml,
      drvs.docbookXslNons,
      drvs.links,
    ],
  }
}
