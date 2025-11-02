{
  lib,
  drvs,
  sharedMimeInfo | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.bz2",
      sha256sum = "32dc32ae39ff1c1bf8434dd3b36770b48538a1772bc0298509d034f057005992"
    },
    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-I/usr/include/libxml2"
      ],
    },
    preConfigurePhase = [
      m%"
      for f in $(find ${SRC}/ -type f -name '*.xml' ); do
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
      done
      "%,
    ],
    biDrvs = [
      drvs.libxslt,
      drvs.xmlto,
      drvs.bash,
      drvs.libxml2,
      drvs.docbookXml,
      drvs.docbookXslNons,
      drvs.links,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.gettext,
    ],
  }
}
