{
  lib,
  drvs,
  mandoc | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://mandoc.bsd.lv/snapshots/mandoc-1.14.6.tar.gz",
        sha256sum = "8bf0d570f01e70a6e124884088870cbed7537f36328d512909eb10cd53179d9c",
      },

      preConfigurePhase = [
        m%"printf "
            UTF8_LOCALE=en_US.UTF-8
            CC=\"${CC}\"
            CFLAGS=\"${CFLAGS}\"
            LDFLAGS=\"${LDFLAGS}\"
            PREFIX="/usr"
            SBINDIR="/usr/bin"
            " >> configure.local "%
      ],

      separateBuildDir = false,
      biDrvs = [
        drvs.zlibNg,
      ]
    }
}
