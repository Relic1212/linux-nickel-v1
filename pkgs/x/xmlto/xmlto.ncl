{
  lib,
  drvs,
  xmlto | lib.AutomakePackage = {
    singleSource = {
      uri = "https://pagure.io/xmlto/archive/0.0.29/xmlto-0.0.29.tar.gz",
      sha256sum = "40504db68718385a4eaa9154a28f59e51e59d006d1aa14f5bc9d6fded1d6017a"
    },
    extraConfigureFlags = [
      "BASH=/usr/bin/bash"
    ],
    biDrvs = [
      drvs.bash,
      drvs.libxslt,
      drvs.docbookXml,
      drvs.libxml2,
    ]
  }
}
& {
  lib,
  drvs,
  docbook | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/docbook/docbook/archive/41f0c3d5dea67901a2f4874427665ec755243459.zip",
      sha256sum = "286420bb21a519b690286c39bec681dea8caf3982242a9ff289d0421a1ec9c2f"
    }
  }
}
& {
  lib,
  drvs,
  docbookXsl | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-1.79.2.zip",
      sha256sum = "853dce096f5b32fe0b157d8018d8fecf92022e9c79b5947a98b365679c7e31d7"
    },
    biDrvs = [
      drvs.libxslt,
      drvs.docbookXml,
      drvs.libxml2,
    ],
    extraMakeArgs = [
      "XSLT=/usr/bin/xsltproc"
    ]
  }
}
& {
  lib,
  drvs,
  docbookXml | lib.Package = {
    singleSource = {
      uri = "https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip",

      sha256sum = "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
    },
    biDrvs = [
      drvs.libxslt,
      drvs.libxml2,
    ],
    separateBuildDir = false,
    # https://www.linuxfromscratch.org/blfs/view/svn/pst/docbook.html
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/xml/docbook/xml-dtd-4.5",
      "install -d -m0755 ${DEST}/etc/xml",
      "cp -v -af docbook.cat *.dtd ent/ *.mod  ${DEST}/usr/share/xml/docbook/xml-dtd-4.5",
      "xmlcatalog --noout --create ${DEST}/etc/xml/docbook",
    ]
  }
}
