{
  lib,
  drvs,
  kwallet | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://invent.kde.org/frameworks/kwallet/-/archive/v6.8.0/kwallet-v6.8.0.tar.gz",
        sha256sum = "7373e04b5d01beb219053d9f1bef444e47f10e38ddba35e231e5907a23d1e9ce"
      }
    }
}
& {
  lib,
  drvs,
  ecm | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://invent.kde.org/frameworks/extra-cmake-modules/-/archive/v6.8.0/extra-cmake-modules-v6.8.0.tar.gz",
        sha256sum = "267811fe39c2b79bca8c966bf582db49d98e044e44b31a5c63b5dd3b076fa0a3"
      },
      biDrvs = [
        drvs.qtbase,
      ]
    }
}
