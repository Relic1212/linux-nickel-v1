{
  lib,
  drvs,
  kmscon | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/kmscon/kmscon/archive/refs/tags/v10.1.1.tar.gz",
      sha256sum = "0459d111eb9a12d7b8981492957043b5326a6ee91b7351575f8fd402d745eeb3",
    },
    extraMesonArgs = [
      "-Dtests=false",
    ],

    preConfigurePhase = [
      m%"sed -i "s@shared_module@library@g" ${SRC}/src/*/meson.build"%,
    ],

    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.libxkbcommon,
      drvs.libtsm,
      drvs.eudev,
      drvs.zlibNg,
    ],
  }
}
