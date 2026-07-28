{
  lib,
  drvs,
  firewalld | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/firewalld/firewalld/archive/refs/tags/v2.5.0.tar.gz",
      sha256sum = "a5844f0d1e80ec6a6a5a155dbb7127fe73b53dd87d6df15312fbddd7be764d44",
    },
    separateBuildDir = false,
    extraConfigureFlags = [
      "--disable-docs",
      "--disable-nls",
    ],
    configureScript = "bash -- ${SRC}/configure",

    preConfigurePhase = [
      m%"sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${SRC}/configure.ac"%,
      m%"
      for f in $(find ${SRC} -type f -name '*.xml*' ); do
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
      done
      "%,
      m%"
      for f in $(find ${SRC} -type f -name '*.xml.in' ); do
        sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${f}
      done
      "%,
      m%"
      for f in $(find ${SRC} -type f -name '*.xsl.in' ); do
        sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${f}
      done
      "%,
    ],

    perlProvider = drvs.perlDynamic,

    biDrvs = [
      drvs.gettext,
      drvs.pythonFull,
      drvs.docbookXslNons,
      drvs.docbookXml,
      drvs.bash,
      drvs.intltool,
      drvs.perlXmlParserDynamic,
      drvs.muslShared,
    ],
    pDrvs = [
      drvs.glib,
      drvs.libxml2,
    ]
  }
}
