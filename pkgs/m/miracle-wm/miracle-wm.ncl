{
  lib,
  drvs,
  miracleWm | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/miracle-wm-org/miracle-wm/archive/refs/tags/v0.6.2.tar.gz",
      sha256sum = "f10f9c0bf03b815a15265171d4926221e45fe0ca2e997d31f69ba34a3839a2b3"
    },

    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      # drvs.libudevZero,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.lua,

      # For optional features
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,

      # X11
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
      drvs.xcbRenderutil,
      drvs.libxfont2,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.openssl,
      drvs.xcbUtilWm,
    ]
  }
}
& {
  lib,
  drvs,
  mir | lib.CmakePackage = {

    singleSource = {
      uri = "https://github.com/canonical/mir/releases/download/v2.21.1/mir-2.21.1.tar.xz",
      sha256sum = "ed7cb0701298e5e4f7401462b03c073735543c37dca74ae60eb2328aeb1d9a51"
    },

    generator = "Ninja",

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.eudev,
      # drvs.libudevZero,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libffi,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.freetype,
      drvs.fontconfig,
      drvs.zlibNg,
      drvs.harfbuzz,
      drvs.glib,
      drvs.hwdata,
      drvs.linuxHeaders,
      drvs.nlohmannJson,
      drvs.tomlplusplus,
      drvs.utilLinux,
      drvs.libyaml,
      drvs.boost,

      # For optional features
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,

      # X11
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
      drvs.xcbRenderutil,
      drvs.libxfont2,
      drvs.libfontenc,
      drvs.libxcvt,
      drvs.libxshmfence,
      drvs.xwayland,
      drvs.libxkbfile,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.glm,
      drvs.libepoxy,
    ]
  }
}
& {
  lib,
  drvs,
  glm101 | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/g-truc/glm/archive/refs/tags/1.0.1.tar.gz",
      sha256sum = "9f3174561fd26904b23f0db5e560971cbf9b3cbda0b280f04d5c379d03bf234c"
    },
    generator = "Ninja",
  }
}
& {
  lib,
  drvs,
  lttngUst | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.14.0.tar.bz2",
      sha256sum = "82cdfd304bbb2b2b7d17cc951a6756b37a9f73868ec0ba7db448a0d5ca51b763",
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
      drvs.muslShared,
    ],
    isStatic = false,
    buildEnv._isStatic = false,
    extraConfigureFlags = [
      #     "--enable-shared=yes",
      "--disable-numa",
      "--disable-examples",
      "--disable-python-agent"
    ],
    preConfigurePhase = [
      #   "sed -i 's@cd tests@echo true#@g' ${SRC}/Makefile.am",
      #   "sed -i 's@tests@@g' ${SRC}/Makefile.am",

      #     "sed -i 's@cd tests@echo true#@g' ${SRC}/Makefile.in",
      #   "sed -i 's@tests@@g' ${SRC}/Makefile.in",
    ],

    #separateBuildDir = false,
  }
}
& {
  lib,
  drvs,
  lttngUst212 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.12.10.tar.bz2",
      sha256sum = "aa802851c6d08c653ac1dd7da8f552baaa5d87e9b03c2d6a8b7a04322e53dc47"
    },

    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
    extraConfigureFlags = [
      "--enable-shared=yes",
      "--disable-numa",
      #"--disable-examples",
    ],

    preConfigurePhase = [
      #   m%"sed -i 's@if test "$enable_shared" = no@if test "$enable_shared" = yes@g' ${SRC}/configure"%,
    ]
  }
}
& {
  lib,
  drvs,
  lttngUst213 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-ust/lttng-ust-2.13.9.tar.bz2",
      sha256sum = "2ad6d69a54a1d924c18a4aa7a233db104e3cc332bcdd240e196bf7adbed3f712"
    },

    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
    extraConfigureFlags = [
      #     "--enable-shared=yes",
      "--disable-numa",
      "--disable-examples",
    ],

    preConfigurePhase = [
      m%"sed -i 's@if test "$enable_shared" = no@if test "$enable_shared" = yes@g' ${SRC}/configure"%,
    ]
  }
}
& {
  lib,
  drvs,
  lttngTools | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-tools/lttng-tools-2.14.0.tar.bz2",
      sha256sum = "d8c39c26cec13b7bd82551cd52a22efc358b888e36ebcf9c1b60ef1c3a3c2fd3"
    },
    biDrvs = [
      drvs.pkgconf,
      drvs.popt,
      drvs.libxml2,
      drvs.liburcu,
    ],
  }
}
& {
  lib,
  drvs,
  lttngModules | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/lttng-modules/lttng-modules-2.14.0.tar.bz2",
      sha256sum = "f2261e738b1dd1027640e5ba3040dee292241b847d5745766b3ba640e168c94a"
    },
    biDrvs = [
      drvs.pkgconf,
    ],
  }
}
& {
  lib,
  drvs,
  liburcu | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://lttng.org/files/urcu/userspace-rcu-0.15.3.tar.bz2",
      sha256sum = "26687ec84e3e114759454c884a08abeaf79dec09b041895ddf4c45ec150acb6d"
    }
  }
}
