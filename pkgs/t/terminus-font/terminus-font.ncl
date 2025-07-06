{
  lib,
  pythonFull,
  bdftopcf,

  terminusFont | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://sourceforge.net/projects/terminus-font/files/terminus-font-4.49/terminus-font-4.49.1.tar.gz",
      sha256sum = "d961c1b781627bf417f9b340693d64fc219e0113ad3a3af1a3424c7aa373ef79"
    },
    separateBuildDir = false,
    biDrvs =
      lib.biMap [
        pythonFull,
        bdftopcf,
      ]
  }
}
& {
  lib,
  pkgconf,
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

  bdftopcf | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/util/bdftopcf-1.1.2.tar.xz",
      sha256sum = "bc60be5904330faaa3ddd2aed7874bee2f29e4387c245d6787552f067eb0523a"
    },
    biDrvs =
      lib.biMap [
        pkgconf,
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
      ]
  }
}
