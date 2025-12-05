{
  lib,
  drvs,
  nwgDrawer | lib.MakePackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/nwg-piotr/nwg-drawer/archive/refs/tags/v0.7.4.tar.gz",
          sha256sum = "0caa9f3a5efbd7492ce57fc6952e7f78e2d6ee71d4a430aeb0aa7535abecdab5",
        }
      },
      {
        src = {
          uri = "https://slackware.lngn.net/pub/source/nwg-drawer/nwg-drawer-vendor-0.7.4.tar.xz",
          sha256sum = "bf5934538e44ace20f8255ab1251546c7bb99bfce1963c8dd812c76257af5446"
        },
        dest = "vendor",
      }
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static expat gtk+-3.0 epoxy xi)"
      ]
    },

    extraEnv = {
      CGO_LDFLAGS = buildEnv.LDFLAGS
    },
    separateBuildDir = false,

    configurePhase = [
      # "cd ${SRC}",
      "export GOROOT=/usr/lib/go",
      "export GOMODCACHE=${SRC}/go-mod",
      "export CGO_ENABLED=1",
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],
    buildPhase = [
      m%"go build -ldflags "-linkmode 'external' -extldflags '-static'"  -v -o bin/nwg-drawer ."%
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/share/nwg-drawer",
      "cp -r desktop-directories ${DEST}/usr/share/nwg-drawer",
      "cp -r img ${DEST}/usr/share/nwg-drawer",
      "install -m0755 drawer.css ${DEST}/usr/share/nwg-drawer",
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 bin/nwg-drawer ${DEST}/usr/bin",
      "install -Dm 644 -t \"${DEST}/usr/share/licenses/nwg-drawer\" LICENSE",
      "install -Dm 644 -t \"${DEST}/usr/share/doc/nwg-drawer\" README.md",
    ],

    makeTargets = [
      "build"
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],

    llvmProvider = drvs.llvmFull,
    # 
    biDrvs = [

      #drvs.pythonFull,
      drvs.atSpi2Core,
      drvs.basu,
      drvs.cairoXlib,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.findutils,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.gettext,
      # drvs.glib,
      drvs.glibDynamic,
      drvs.go_1_24,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.gtk3X11,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.isoCodes,
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
      drvs.libxi,
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
      drvs.muslShared,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.pkgconf,
      drvs.pythonDynamicPic,
      drvs.pythonSetuptools,
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
      drvs.gtkLayerShell,
    ],
  }
}
& (
  import "../nwg/nwg-look.ncl"
)
