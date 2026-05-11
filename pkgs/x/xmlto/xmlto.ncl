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
    preConfigurePhase = [
      m%"
      for f in $(find ${SRC} -type f); do
        sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${f}
      done
      "%,
      m%"
      for f in $(find ${SRC}/doc -type f -name '*.xml' ); do
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
        sed -i 's@http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd@/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd@g' ${f}
      done
      "%,
    ],
    biDrvs = [
      drvs.bash,
      drvs.libxslt,
      drvs.docbookXml,
      drvs.libxml2,
      drvs.docbookXslNons,
      drvs.flex,
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
    ],
    preConfigurePhase = [
      m%"sed -i 's@$(MAKE) -C tests@echo NOTHING@g' ${SRC}/Makefile"%,
      "rm -rf ${SRC}/tests",
    ]
  }
}
& {
  lib,
  drvs,
  docbookXml | lib.Package = {
    singleSource = {
      # uri = "https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip",
      uri = "https://archive.docbook.org/xml/4.5/docbook-xml-4.5.zip",

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
& {

  lib,
  drvs,
  docbookXslNons | lib.Package = {
    singleSource = {
      uri = "https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2",
      sha256sum = "ee8b9eca0b7a8f89075832a2da7534bce8c5478fc8fc2676f512d5d87d832102"
    },
    separateBuildDir = false,
    biDrvs = [
      # drvs.bash,
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2",
      # "for f in $(find . -type d -maxdepth 1); do install -m0755 ${f} ${DEST}/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2; done",
      "cp -r * ${DEST}/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2",

      # "for f in $(find . -name '*.xsl'); do install -m0755 ${f} ${DEST}/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2; done",
    ]
  }
}
& {
  lib,
  drvs,
  links | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://links.twibright.com/download/links-2.30.tar.gz",
      sha256sum = "7f0d54f4f7d1f094c25c9cbd657f98bc998311122563b1d757c9aeb1d3423b9e"
    }
  }
}
