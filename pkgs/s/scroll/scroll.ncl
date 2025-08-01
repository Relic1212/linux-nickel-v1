{
  lib,
  drvs,
  scroll | lib.MesonPackage = {

    sourceInputs = [
      {
        src = {
            uri = "https://github.com/dawsers/scroll/archive/refs/tags/1.11.3.tar.gz",
            sha256sum = "d9a9182d3168eca06ab8a9096b32b6f5fc9fc1aa44a30dd97ed5e3a13dd23d48"
  
        }
      },
      {
        src = {
   
          uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.0/downloads/wlroots-0.19.0.tar.gz",
          sha256sum = "aefb0fe2633b0aad1d66123b2f41afab004fb625e2a7790492cdd39a805cac91",
        
        
        },
        dest = "subprojects/wlroots"
      }
    ],
    buildEnv.EXTRA_LDFLAGS = ["-lc++"],
    # baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,

    extraMesonArgs = [
   



        "-Dwlroots:backends=drm,libinput,x11",
        "-Dwlroots:xwayland=enabled",
        "-Dwlroots:color-management=enabled",
        "-Dgdk-pixbuf=enabled",
        "-Dtray=enabled",
        "-Dman-pages=enabled",
    ],

    preConfigurePhase = [
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

      "sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build",
    ],
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
