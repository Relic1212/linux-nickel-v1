{
  lib,
  drvs,
  xdgUtils | lib.AutotoolsPackage = {
    separateBuildDir = false,
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v1.2.1/xdg-utils-v1.2.1.tar.gz",
      sha256sum = "f6b648c064464c2636884c05746e80428110a576f8daacf46ef2e554dcfdae75"
    },

    preConfigurePhase = [
      m%"
      for f in $(find ${SRC} -type f); do
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.3/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
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
    enableParallel = false,
  }
}
