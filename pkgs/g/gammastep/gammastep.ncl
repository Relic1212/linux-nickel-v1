{
  lib,
  drvs,
  gammastep | lib.AutomakePackage
    = {
      singleSource = {
        uri = "https://gitlab.com/chinstrap/gammastep/-/archive/v2.0.9/gammastep-v2.0.9.tar.gz",
        sha256sum = "bbb9d90e1cf30920c1017db4ce5c4652e4c7843fd4c4e34164d99ecbc3bbb4c0"
      },
      biDrvs = [
        drvs.gettext,
      ]
    }
}
