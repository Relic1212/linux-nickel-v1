{
  lib,
  drvs,
  python2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz",
      sha256sum = "b62c0e7937551d0cc02b8fd5cb0f544f9405bafc9a54d3808ed4594812edef43",
    },
    preBuildPhase = [
      lib.functions.writeFile "Modules/Setup.local" (import "Setup.local" as 'Text),
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.openssl,
      drvs.libffi,
      drvs.zlibNg,
    ]
  },
  python2Symlink | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "ln -s python2 python",
    ]
  }
}
