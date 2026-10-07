{
  lib,
  drvs,
  xwayland | lib.MesonPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/xserver/xwayland-24.1.4.tar.xz",
      sha256sum = "d96a78dbab819f55750173444444995b5031ebdcc15b77afebbd8dbc02af34f4"
    },
    buildEnv.EXTRA_LDFLAGS = [
      "-lc++",
      # "$(pkg-config --libs --static glesv2)"
    ],

    extraMesonArgs = [
      "-Dxvfb=false",
      "-Dglx=true",
      "-Dxdmcp=false",
      "-Dxdm-auth-1=false",
      "-Dsecure-rpc=false",
      "-Dxres=true",
      # "-Dxace=false",
      "-Dxinerama=false",
      "-Dxv=false",
      "-Dglamor=false",
    ],
    preConfigurePhase = [
      "sed -i 's|XkbFreeGeomOverlayKeys|XkbFreeGeomOverlayKeys__xwayland|g' ${SRC}/xkb/XKBGAlloc.c",
      "sed -i 's|XkbFreeGeomOverlayKeys|XkbFreeGeomOverlayKeys__xwayland|g' ${SRC}/xkb/xkbgeom.h",
    ],

    llvmProvider = drvs.llvmFull,
    pDrvs = [
      # drvs.jsonC,
      # drvs.libepoxy,
      drvs.libxcvt,
      drvs.libxfont2,
      drvs.libxkbfile,
      drvs.libxshmfence,
      drvs.mesaGlx,
      # drvs.mesa2,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.xcbUtilErrors,
      drvs.libxf86vm,
    ],
  }
}
