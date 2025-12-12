{
  lib,
  drvs,
  scroll | lib.MesonPackage = {

    sourceInputs = [
      {
        src = {
          uri = "https://github.com/dawsers/scroll/archive/refs/tags/1.12.2.tar.gz",
          sha256sum = "73e48afc5db7f255f3689ed1ec413c551b76865100b5d87b5225fb3ddc9e0908"
        }
      },
      # {
      #   src = {

      #     uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.1/downloads/wlroots-0.19.1.tar.gz",
      #     sha256sum = "f6bace4eac8708010430411a64f42055249ee7742cac29efa1a4036988291b2b",
      #   },
      #   dest = "subprojects/wlroots"
      # }
    ],
    buildEnv.EXTRA_LDFLAGS = ["-lc++"],
    extraMesonArgs = [
      "-Dwlroots:backends=drm,libinput,x11",
      "-Dwlroots:xwayland=enabled",
      "-Dwlroots:color-management=enabled",
      "-Dgdk-pixbuf=enabled",
      "-Dtray=enabled",
      "-Dman-pages=enabled",
    ],

    preConfigurePhase =
      [
        m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_sway(@g"
                for f in $(find ${SRC} -type f -name '*.h' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_sway(@g" $f
                    sed -i "s@_${1}_sway(@_${1}(@g" $f
                done
                for f in $(find ${SRC} -type f -name '*.c' |grep -v subprojects);do
                    sed -i "s@${1}(@${1}_sway(@g" $f
                    sed -i "s@_${1}_sway(@_${1}(@g" $f
                done
            }
            "%,
        "fix_symbol \"list_insert\"",
        "fix_symbol \"parse_boolean\"",
        # "sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build",
      ]
      @ (
        std.array.map
          (
          # clashes with libxkbcommon
          fun s => "sed -i 's|expand_path|scroll_private__expand_path|g' ${SRC}/%{s}"
          )
          [
            "common/stringop.c",
            "sway/commands/output/color_profile.c",
            "sway/commands/output/background.c",
            "sway/commands/input/xkb_file.c",
            "include/stringop.h",
          ]
      ),
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
      drvs.fribidi,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
    ]
  }
}
