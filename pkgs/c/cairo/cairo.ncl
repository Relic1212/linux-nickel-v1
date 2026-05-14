{
  lib,
  drvs,
  cairo | lib.MesonPackage = {
    singleSource.uri = "https://gitlab.freedesktop.org/cairo/cairo/-/archive/1.18.2/cairo-1.18.2.tar.gz",
    singleSource.sha256sum = "7bbfb469b89b1f60584b4f39a1366789b7625a5796905870e108b6c0e8ca8216",
    pDrvs = [
      drvs.pixman,
      drvs.fontconfig,
      drvs.libpng,
    ],
    extraMesonArgs = [
      "-Dzlib=enabled",
      "-Dfreetype=enabled",
      "-Dfontconfig=enabled",
      "-Dpng=enabled"
    ],
  }
}
& {
  lib,
  drvs,
  cairo,
  cairo3 | lib.MesonPackage =
    cairo
    & {
      extraMesonArgs | priority 1 =
        cairo.extraMesonArgs
        @ [
          "-DCAIRO_HAS_GOBJECT_FUNCTIONS=1"
        ]
    }
}
& {
  drvs,
  lib,
  cairo,
  cairoGobject =
    cairo
    & {
      extraMesonArgs | priority 1 =
        cairo.extraMesonArgs
        @ [
          "-Dglib=enabled",
        ],
      pDrvs | priority 1 =
        cairo.pDrvs
        @ [
          drvs.glib,
          drvs.gobjectDynamic,
          # drvs.libffi,
          # drvs.pcre2,
        ]
    }
}
& {
  drvs,
  lib,
  cairo,
  cairoXlib =
    cairo
    & {
      extraMesonArgs | priority 1 =
        cairo.extraMesonArgs
        @ [
          "-Dglib=enabled",
          "-Dxlib=enabled",
        ],
      # pDrvs | priority 1 = [],
      pDrvs | priority 1 =
        cairo.pDrvs
        @ [
          drvs.glib,
          # drvs.libffi,
          # drvs.pcre2,
          # drvs.libxcursor,
          # drvs.xorgMacros,
          # drvs.xorgproto,
          # drvs.xtrans,
          # drvs.libxcb,
          # drvs.xcbProto,
          # drvs.libxau,
          # drvs.libx11,
          # drvs.libxrender,
          # drvs.libxfixes,
          # drvs.xcbRenderutil,
          # drvs.libxfont2,
          # drvs.libfontenc,
          # drvs.libxcvt,
          # drvs.libxshmfence,
          # drvs.xwayland,
          drvs.libxkbfile,
          drvs.openssl,
          # drvs.xcbUtilWm,
          drvs.libxext,
          # drvs.libxf86vm,
          # drvs.libxrandr,
        ]
    }
}
