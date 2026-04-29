{
  lib,
  drvs,
  tofi | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/philj56/tofi/archive/refs/tags/v0.9.1.tar.gz",
      sha256sum = "dd55347b509af786f133def64f3a86f1db258b5e196de80e53d62827bdcc37bc",
    },
    preConfigurePhase =
      [
        # m%"sed -i "s@subdir('test')@@g" ${SRC}/meson.build"%,
      ]
      @ (
        std.array.map
          (fun s =>
            m%"sed -i 's@utf32_to_utf8@utf32_to_utf8_tofi@g' ${SRC}/%{s}"%
          )
          [
            "src/unicode.h",
            "src/input.c",
            "src/unicode.c",
            "src/config.c",
          ]
      ),
    biDrvs = [
      drvs.muslFts,
      drvs.atSpi2Core,
      drvs.cairoXlib,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibDynamic,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.harfbuzz,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libfontenc,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libx11,
      drvs.libxau,
      drvs.libxcb,
      drvs.libxcursor,
      drvs.libxcvt,
      drvs.libxfixes,
      drvs.libxfont2,
      drvs.libxkbcommon,
      drvs.libxkbfile,
      drvs.libxrender,
      drvs.libxshmfence,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.muslShared,
      drvs.ncurses,
      drvs.openssl,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xcbProto,
      drvs.xcbRenderutil,
      drvs.xcbUtilWm,
      drvs.xorgMacros,
      drvs.xorgproto,
      drvs.xtrans,
      drvs.xwayland,
      drvs.zlibNg,
      drvs.isoCodes,
      drvs.libxext,
      drvs.libxf86vm,
      drvs.libxrandr,
      drvs.gtk3,
    ]
  }
}
