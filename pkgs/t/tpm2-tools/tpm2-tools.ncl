{
  lib,
  drvs,
  tpm2Tools
    |
    ##
    #  lib.AutomakePackage
    lib.AutotoolsPackage
    ##
    = {
      singleSource = {
        uri = "https://github.com/tpm2-software/tpm2-tools/archive/refs/tags/5.7.tar.gz",
        sha256sum = "714912361fddbd7e01473be9065b2949b5ad2f5dff80063648f00f4eaf38971b"
      },
      preConfigurePhase = [
        "(cd ${SRC} && echo 5.7 > VERSION)",
        # "alias git='echo 5.7'",
        "(cd ${SRC} && sed -i 's|git describe|# git describe|g' bootstrap)",
        "(cd ${SRC} && ./bootstrap)",
        # "unalias git",
      ],

      pkgconfProvider,
      biDrvs = [
        drvs.perl,
        drvs.automake,
        drvs.autoconf,
        drvs.m4,
        drvs.libtool,
        pkgconfProvider,
        drvs.intltool,
        drvs.gtkDoc,
        drvs.autoconfArchive,
        drvs.openssl,
        drvs.jsonC,
        drvs.curl,
        drvs.zlibNg,
        drvs.libpsl,
        drvs.utilLinux,
        drvs.linuxHeaders,
        drvs.tpm2Tss,
      ]
    }
}
