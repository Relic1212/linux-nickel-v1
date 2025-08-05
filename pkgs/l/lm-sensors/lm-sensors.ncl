{
  lib,
  drvs,
  lmSensors | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/hramrach/lm-sensors/archive/refs/tags/V3-6-2.tar.gz",
      sha256sum = "c6a0587e565778a40d88891928bf8943f27d353f382d5b745a997d635978a8f0"
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.gettext,
      drvs.flex,
      drvs.m4,
      drvs.bison,
    ],

    extraMakeArgs = [
      "CC=clang",
      "SBINDIR=/usr/bin",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
      "SBINDIR=/usr/bin",
    ]
  },
  lmSensorsSensors | lib.MakePackage =
    lmSensors
    & {
      postInstallPhase = [
        "rm ${DEST}/usr/lib -rf",
        "rm ${DEST}/usr/bin/sensors-conf-convert",
        "rm ${DEST}/usr/bin/sensors-detect",
        "rm ${DEST}/usr/bin/pwmconfig",
        "rm ${DEST}/usr/bin/fancontrol",
      ]
    }
}
