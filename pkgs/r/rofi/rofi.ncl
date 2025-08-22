{
  lib,
  drvs,
  rofi | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/davatorium/rofi/archive/refs/tags/2.0.0-beta1.tar.gz",
      sha256sum = "17934ff9922b25ba93c659956940d96aa4571523c2b4bdff9e9dee40e208ca24",
    },
    sourceInputs = [
      {
        src =
          singleSource
      },
      {
        src = {
          uri = "https://github.com/sardemff7/libgwater/archive/42a145150cff135be377754486c504836ddea836.tar.gz",
          sha256sum = "17cfa6fdb1d8f0eeb6ca083c8abb3f032b9380ce5b0c13f846d0bb277069ec8b"
        },
        dest = "subprojects/libgwater"
      },
      {
        src = {
          uri = "https://github.com/sardemff7/libnkutils/archive/72bd7fb07f627a864e724639eea9fab6cccbd77c.tar.gz",
          sha256sum = "319af84464cb45750d6f6ffda8711f75d3f5c898e31124ce69bbbf99b48c8c69"
        },
        dest = "subprojects/libnkutils"
      }
    ],
    extraMesonArgs = [
      # "-Dxcb=enabled",
      "-Dwayland=enabled",
      "-Dimdkit=true",
      "-Dwindow=true",
    ],
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.utf8proc,
      drvs.glib,
      drvs.pcre2,
      drvs.jsonC,
      drvs.mesa2,
      drvs.libelf,
      drvs.libpciaccess,
      drvs.libdrm,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libevdev,
      drvs.mtdev,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
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
      drvs.flex,
      drvs.bison,
      drvs.m4,
      drvs.xcbUtilKeysyms,
      drvs.xcbUtil,
      drvs.xcbImdkit,
    ],
  }
}
