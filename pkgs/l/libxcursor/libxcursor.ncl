{
  lib,
  drvs,
  libxcursor | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xorg/lib/libxcursor/-/archive/libXcursor-1.2.3/libxcursor-libXcursor-1.2.3.tar.gz",
      sha256sum = "840292e5cdfae8d8b795ba00bcbe620a0de0af6ae1847e142df09dec86a70edc"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
    ]
  }
}
& {
  lib,
  drvs,
  libxfixes | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libXfixes-6.0.1.tar.xz",
      sha256sum = "b695f93cd2499421ab02d22744458e650ccc88c1d4c8130d60200213abc02d58"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
    ]
  }
}
& {
  lib,
  drvs,
  xorgproto | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xorg/proto/xorgproto/-/archive/xorgproto-2024.1/xorgproto-xorgproto-2024.1.tar.gz",
      sha256sum = "c92466091663b68d93997eab4f329d0be511cb448a61b61fe74a738f2698b77c"
    },
    biDrvs = [
      drvs.xorgMacros,
    ]
  }
}
& {
  lib,
  drvs,
  xorgMacros | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xorg/util/macros/-/archive/util-macros-1.20.1/macros-util-macros-1.20.1.tar.gz",
      sha256sum = "95c4331a2a7f4882374b9bbc845e522a4f1c77d95f495176300bf91d905c9b60"
    }
  }
}
& {
  lib,
  drvs,
  libxrender | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xorg/lib/libxrender/-/archive/libXrender-0.9.11/libxrender-libXrender-0.9.11.tar.gz",
      sha256sum = "4cd5aca5b948a80bb7c3d5060eb97b8a8199234c0c19fe34d35c5c838923230b"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
    ],
  }
}
& {
  lib,
  drvs,
  libx11 | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libX11-1.8.10.tar.xz",
      sha256sum = "2b3b3dad9347db41dca56beb7db5878f283bde1142f04d9f8e478af435dfdc53"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
    ],
  }
}
& {
  lib,
  drvs,
  xtrans | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/xtrans-1.5.1.tar.xz",
      sha256sum = "dea80fbd8c3c941495b4b1d2785cb652815d016849a0d2ef90d1140de916993e"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.libxcb,
      drvs.xcbProto,
    ],
  }
}
& {
  lib,
  drvs,
  libxcb | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libxcb-1.17.0.tar.xz",
      sha256sum = "599ebf9996710fea71622e6e184f3a8ad5b43d0e5fa8c4e407123c88a59a6d55"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.pythonFull,
      drvs.xcbProto,
      drvs.libxau,
    ],
  }
}
& {
  lib,
  drvs,
  xcbProto | lib.AutomakePackage = {
    singleSource = {
      uri = "https://xorg.freedesktop.org/archive/individual/proto/xcb-proto-1.17.0.tar.xz",
      sha256sum = "2c1bacd2110f4799f74de6ebb714b94cf6f80fb112316b1219480fd22562148c"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.pythonFull,
    ],
  }
}
& {
  lib,
  drvs,
  libxau | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libXau-1.0.11.tar.xz",
      sha256sum = "f3fa3282f5570c3f6bd620244438dbfbdd580fc80f02f549587a0f8ab329bbeb"
    },
    biDrvs = [
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.pythonFull,
    ],
  }
}
& {
  lib,
  drvs,
  libxi | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libXi-1.8.2.tar.xz",
      sha256sum = "d0e0555e53d6e2114eabfa44226ba162d2708501a25e18d99cfb35c094c6c104"
    },

    biDrvs = [
      drvs.pkgconf,
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
    ]
  }
}
& {
  lib,
  drvs,
  libxinerama | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.x.org/archive//individual/lib/libXinerama-1.1.5.tar.xz",
      sha256sum = "5094d1f0fcc1828cb1696d0d39d9e866ae32520c54d01f618f1a3c1e30c2085c"
    },
    biDrvs = [
      drvs.pkgconf,
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
    ]
  }
}
