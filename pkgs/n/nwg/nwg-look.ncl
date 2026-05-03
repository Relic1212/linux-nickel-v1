{
  lib,
  drvs,
  nwgLook | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/nwg-piotr/nwg-look/archive/refs/tags/v1.0.6.tar.gz",
      sha256sum = "ddaba674253fbbf8f3ee7392315e51408af445adb85ed4b0f70e50301801720d"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://slackware.lngn.net/pub/source/nwg-look/nwg-look-vendor-1.0.6.tar.xz",
          sha256sum = "2851c2589bce9c1b4f3925ded6b7a9712361c66ac178266bc715a5215e28266c"
        },
        dest = "vendor",
      }
    ],
    # buildEnv={
    #   EXTRA_LDFLAGS = [
    #     "$(pkg-config --static --libs gtk+-3.0)"
    #   ],
    # },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static expat gtk+-3.0 epoxy xi)",
        "-L/tmp/workdir/src/dlopen_lib",
        "-ldlopen",
      ]
    },

    extraEnv = {
      CGO_LDFLAGS = buildEnv.LDFLAGS
    },

    # 

    separateBuildDir = false,
    preConfigurePhase = [
      lib.functions.writeFile "dlopen.c" (import "nwg_look_dlopen.c" as 'Text),
      "${CC} ${CFLAGS} -Werror -c dlopen.c -o dlopen.o",
      "mkdir dlopen_lib",
      "${AR} rcs dlopen_lib/libdlopen.a dlopen.o",
      "${RANLIB} dlopen_lib/libdlopen.a",
      "rm dlopen.c",
    ],
    configurePhase = [
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    # makeTargets=[
    #   "build"
    # ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],

    # https://mt165.co.uk/blog/static-link-go/
    buildPhase = [
      m%"go build -ldflags "-linkmode 'external' -extldflags '-static'"  -v -o bin/nwg-look ."%,
      # m%"go build -ldflags "-extldflags '-static'"  -v -o bin/nwg-look ."%,
    ],
    # installPhase = [],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,

    biDrvs = [

      #drvs.pythonFull,
      drvs.atSpi2Core,
      drvs.basu,
      drvs.cairoXlib,
      # drvs.cairoGobject,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.findutils,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.gettext,
      drvs.glib,
      drvs.glibDynamic,
      # drvs.go_1_24,
      drvs.go_1_26,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.gtk3X11,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.jsonC,
      drvs.lcms,
      drvs.libcanberra,
      drvs.libdisplayinfo,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxyX11,
      drvs.libevdev,
      drvs.libffi,
      drvs.libfontenc,
      drvs.libinput,
      drvs.libjpegTurbo,
      drvs.libogg,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libtool,
      drvs.libvorbis,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxcursor,
      drvs.libxcvt,
      drvs.libxext,
      drvs.libxf86vm,
      drvs.libxfixes,
      drvs.libxfont2,
      drvs.libxkbcommon,
      drvs.libxkbfile,
      drvs.libxrandr,
      drvs.libxrender,
      drvs.libxshmfence,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.mpdecimal,
      drvs.mtdev,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.pkgconf,
      drvs.readline,
      drvs.scdoc,
      drvs.seatd,
      drvs.simde,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.symbolsNerdFont,
      drvs.vala,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xcbProto,
      drvs.xcbRenderutil,
      drvs.xcbUtilErrors,
      drvs.xcbUtilWm,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.xwayland,
      drvs.xxhash,
      drvs.zlibNg,
      drvs.libxi,
    ],
  }
}
