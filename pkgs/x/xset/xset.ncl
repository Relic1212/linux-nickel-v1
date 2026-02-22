{
  lib,
  drvs,
  xset | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/app/xset-1.2.5.tar.xz",
      sha256sum = "9f692d55635b3862cd63633b1222a87680ec283c7a8e8ed6dd698a3147f75e2f",
    },
    extraEnv = {
      PKG_CONFIG = "\"pkg-config --static\"",
    },
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.libxext,
      drvs.libxt,
      drvs.libsm,
      drvs.libice,
      drvs.libxmu,
    ]
  }
}
