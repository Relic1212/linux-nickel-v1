{
  lib,
  drvs,
  spiceServer | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.spice-space.org/download/releases/spice-server/spice-0.16.0.tar.bz2",
      sha256sum = "0a6ec9528f05371261bbb2d46ff35e7b5c45ff89bb975a99af95a5f20ff4717d",
    },
    extraMesonArgs = [
      "-Dgstreamer=no",
      "-Dsasl=false",
      "-Dspice-common:tests=false",
    ],
    biDrvs = [
      drvs.pythonPyparsing,
    ],
    pDrvs = [
      drvs.spiceProtocol,
      drvs.glib,
      drvs.pixman,
      drvs.openssl,
      drvs.libjpegTurboStatic,
      drvs.lz4,
    ]
  }
}
