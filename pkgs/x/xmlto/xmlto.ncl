{
  lib,
  drvs,
  xmlto | lib.AutomakePackage
    = {
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
      ]
    }
}
& {
  lib,
  drvs,
  docbook | lib.MakePackage
    = {
      singleSource = {
        uri = "https://github.com/docbook/docbook/archive/41f0c3d5dea67901a2f4874427665ec755243459.zip",
        sha256sum = "286420bb21a519b690286c39bec681dea8caf3982242a9ff289d0421a1ec9c2f"
      }
    }
}
& {
  lib,
  drvs,
  docbook-xsl | lib.MakePackage
    = {
      singleSource = {
        uri = "https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-1.79.2.zip",
        sha256sum = "853dce096f5b32fe0b157d8018d8fecf92022e9c79b5947a98b365679c7e31d7"
      },
      biDrvs = [
        drvs.libxslt,
      ],
      extraMakeArgs = [
        "XSLT=/usr/bin/xsltproc"
      ]
    }
}
& {
  lib,
  drvs,
  docbook-xml | lib.MakePackage
    = {
      singleSource = {
        uri = "https://docbook.org/xml/5.2b09/docbook-52b09.zip",
        sha256sum = "748c1efb4c2133b77db0176405b0387d1c2517befe0be2c3090319f0b1dcd587"
      },
      biDrvs = [
        drvs.libxslt,
      ],
    }
}
