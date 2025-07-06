{
  lib,
  libxcursor,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,
  pkgconf,
  zlibNg,
  xcbRenderutil,
  m4,
  pythonFull,

  xcbUtilErrors | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/lib/xcb-util-errors-1.0.1.tar.xz",
      sha256sum = "5628c87b984259ad927bacd8a42958319c36bdf4b065887803c9d820fb80f357"
    },
    biDrvs =
      lib.biMap [
        libxcursor,
        xorgMacros,
        xorgproto,
        xtrans,
        libxcb,
        xcbProto,
        libxau,
        libx11,
        libxrender,
        libxfixes,
        pkgconf,
        zlibNg,
        xcbRenderutil,
        m4,
        pythonFull,
      ]
  }
}
