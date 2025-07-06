{
  lib,
  pkgconf,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,

  libxext | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.x.org/releases/individual/lib/libXext-1.3.6.tar.xz",
      sha256sum = "edb59fa23994e405fdc5b400afdf5820ae6160b94f35e3dc3da4457a16e89753"
    },

    biDrvs =
      lib.biMap [
        pkgconf,
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
& {
  lib,
  pkgconf,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,
  libxext,

  libxf86vm | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.x.org/releases/individual/lib/libXxf86vm-1.1.6.tar.xz",
      sha256sum = "96af414c73ce1d5449ad04be7f9f27fa8330f844b6dda843ef22e3e1befb3ee3"
    },

    biDrvs =
      lib.biMap [
        pkgconf,
        xorgMacros,
        xorgproto,
        xtrans,
        libxcb,
        xcbProto,
        libxau,
        libx11,
        libxrender,
        libxfixes,
        libxext,
      ]
  }
}
& {
  lib,
  pkgconf,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,
  libxext,

  libxrandr | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.x.org/releases/individual/lib/libXrandr-1.5.4.tar.xz",
      sha256sum = "1ad5b065375f4a85915aa60611cc6407c060492a214d7f9daf214be752c3b4d3"
    },

    biDrvs =
      lib.biMap [
        pkgconf,
        xorgMacros,
        xorgproto,
        xtrans,
        libxcb,
        xcbProto,
        libxau,
        libx11,
        libxrender,
        libxfixes,
        libxext,
      ]
  }
}
