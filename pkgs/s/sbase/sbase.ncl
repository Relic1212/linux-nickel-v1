{
  lib,
  drvs,
  sbase | lib.MakePackage = {
    singleSource = {
      fetchMethod = "git",
      uri = "git://git.suckless.org/sbase",
      sha256sum = "b343ded0be4defafb709945117d79dab4e70a242"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    biDrvs = [
      drvs.bison,
      drvs.m4,
    ]
  }
}
& {
  lib,
  drvs,
  ubase | lib.MakePackage = {
    singleSource = {
      fetchMethod = "git",
      uri = "git://git.suckless.org/ubase",
      sha256sum = "e8249b49ca3e02032dece5e0cdac3d236667a6d9"
    },
    extraMakeArgs = [
      "CC=\"${CC}\"",
      "CFLAGS=\"${CFLAGS}\"",
      "LDFLAGS=\"${LDFLAGS}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ]
  }
}
& {
  lib,
  drvs,
  st | lib.MakePackage = {
    singleSource = {
      uri = "git://git.suckless.org/st",
      sha256sum = "a0274bc20e11d8672bb2953fdd1d3010c0e708c5"
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lX11",
        "-lxcb",
        "-lXrender",
        "-lXcursor",
        "-lXau",
      ],
    },
    extraMakeArgs = [
      # "CC=\"${CC}\"",
      # "CFLAGS=\"${CFLAGS}\"",
      # "LDFLAGS=\"${LDFLAGS}\"",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    biDrvs = [
      drvs.pkgconf,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.expat,
      drvs.fontconfig,
      drvs.ncurses,
      ###############################################################
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      drvs.libxft,
      ###################################################
    ]
  }
}
& {
  lib,
  drvs,

  libxft | lib.AutomakePackage = {

    singleSource = {
      uri = "https://gitlab.freedesktop.org/xorg/lib/libxft/-/archive/libXft-2.3.8/libxft-libXft-2.3.8.tar.gz",
      sha256sum = "ba82ef76123ab2ded4a0eab9732c0ad0073d69a6fefd997a78e858b47b222fca"
    },
    biDrvs = [
      drvs.zlibNg,
      drvs.freetype,
      drvs.gperf,
      drvs.expat,
      drvs.fontconfig,
      ###############################################################
      drvs.libxcursor,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.libxcb,
      drvs.xcbProto,
      drvs.libxau,
      drvs.libx11,
      drvs.libxrender,
      drvs.libxfixes,
      ###################################################
    ]
  },
}
