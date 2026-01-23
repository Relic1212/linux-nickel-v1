{
  lib,
  drvs,
  tpm2Tss
    |
    ##
    #  lib.AutomakePackage
    lib.AutotoolsPackage
    ##
    = {
      singleSource = {
        uri = "https://github.com/tpm2-software/tpm2-tss/archive/refs/tags/4.1.3.tar.gz",
        sha256sum = "8a389bda64690910e7af7deaf64703a3faed416dc538c9c3e4f893f24893524d"
      },
      extraConfigureFlags = [
        "--enable-nodl",
        "--disable-tcti-mssim", # microsoft simulator
        "--disable-tcti-swtpm",
      ],
      preConfigurePhase = [
        "(cd ${SRC} && echo 4.1.3 > VERSION)",
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
      ]
    }
}
