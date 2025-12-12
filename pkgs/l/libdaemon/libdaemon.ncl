{
  lib,
  drvs,
  libdaemon | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz",
      sha256sum = "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"
    },
    extraConfigureFlags = [
      "--disable-examples",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ]
  }
}
