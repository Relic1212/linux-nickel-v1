{
  lib,
  drvs,
  crun | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/containers/crun/releases/download/1.18.2/crun-1.18.2.tar.gz",
        sha256sum = "fdd530a398e32c36ccb597a43d17692631257374b9121027d88bbc5bccb24442"
      },
      biDrvs = [
        drvs.pythonFull,
        drvs.yajl,
        drvs.libcap,
        drvs.linuxHeaders,
        drvs.zlibNg,
        drvs.libseccomp,
        drvs.gperf,
        drvs.argpStandalone,
        drvs.pkgconf,
      ],

      extraConfigureFlags = [
        "--disable-systemd",
        "--disable-dl",
      ]
    }
}
