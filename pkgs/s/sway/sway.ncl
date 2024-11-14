{
  lib,
  drvs,
  sway | lib.MesonPackage
    =
      let _sway | lib.MesonPackage
        = {
          name = "sway",

          sourceInputs = [
            {
              src = {
                uri = "https://github.com/swaywm/sway/archive/015e357fce8250cdde03844ca81e9ae982ef4bfb.zip",
                sha256sum = "449a213107680cc234c093e3a21247406bac3fa6e1c9c345a3a9854bd804844c",
              }
            },
            {
              src = {
                uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/e8e76dc2954e1bc4cfe6bbf104996a932b9eb807/wlroots-e8e76dc2954e1bc4cfe6bbf104996a932b9eb807.tar.gz",
                sha256sum = "f89797791f20e14df8319acdfa68e57002fb85efc5977bf22ae9b45fe7583e5d"
              },
              dest = "wlroots"
            }
          ],

          extraMesonArgs = [
            "-Dwlroots:backends=drm,libinput"
          ],

          preConfigurePhase = [
            m%"
            fix_symbol(){
                echo    sed -i "s@${1}(@${1}_sway(@g"
                for f in $(find ${SRC} -type f|grep -v subprojects);do
                    sed -i "s@${1}(@${1}_sway(@g" $f
                    sed -i "s@_${1}_sway(@_${1}(@g" $f
                done
            }
            "%,
            "fix_symbol \"list_insert\"",
            "fix_symbol \"parse_boolean\"",
            "mkdir -p ${SRC}/subprojects",
            "mv ${SRC}/wlroots ${SRC}/subprojects",
          ],
          llvmProvider = drvs.llvmFull,
          biDrvs = [
            drvs.expat,
            drvs.jsonC,
            drvs.pcre2,
            drvs.mesa2,
            drvs.wayland,
            drvs.waylandProtocols,
            drvs.libelf,
            drvs.libpciaccess,
            drvs.libdrm,
            drvs.libxkbcommon,
            drvs.pixman,
            # drvs.eudev,
            drvs.libudevZero,
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
          ]
        }
        in (_sway & { buildEnv.LDFLAGS = _sway.buildEnv.LDFLAGS @ ["-lc++"] }),
}
