{
  lib,
  drvs,
  sbase | lib.MakePackage
    = {
      singleSource = {
        uri = "git://git.suckless.org/sbase",
        sha256sum = "cf1e0643396391213056ebae2f5c25611fc20ea4"
      },
      extraMakeInstallArgs = [
        "PREFIX=/usr"
      ]
    }
}
& {
  lib,
  drvs,
  ubase | lib.MakePackage
    = {
      singleSource = {
        uri = "git://git.suckless.org/ubase",
        sha256sum = "a570a80ed1606bed43118cb148fc83c3ac22b5c1"
      },
      #   extraMakeArgs = [
      #     "CC=\"${CC}\"",
      #     "CFLAGS=\"${CFLAGS}\"",
      #     "LDFLAGS=\"${LDFLAGS}\"",
      #   ],
      extraMakeInstallArgs = [
        "PREFIX=/usr"
      ]
    }
}
& {
  lib,
  drvs,
  "9base" | lib.MakePackage
    = {
      singleSource = {
        uri = "git://git.suckless.org/9base",
        sha256sum = "63916da7bd6d73d9a405ce83fc4ca34845667cce"
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
  st | lib.MakePackage
    = {
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

  libxft | lib.AutomakePackage
    = {

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
