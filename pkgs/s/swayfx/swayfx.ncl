{
  lib,
  drvs,
  swayfx | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {
          # uri = "https://github.com/WillPower3309/swayfx/archive/e0b320417fa493099e8634ca01e00112ee04a8b7.tar.gz",
          # sha256sum = "a34aefbc765505788230843399385ec2b173100c53148fd3bf93ffc50095970d",

          uri = "https://github.com/WillPower3309/swayfx/archive/refs/tags/0.5.2.tar.gz",
          sha256sum = "075e1a9577f96a71154c61997355dce569816fff05a2c535ec15b252a9acbbe1",
        }
      },
      {
        dest = "subprojects/scenefx",
        src = {
          # uri = "https://github.com/wlrfx/scenefx/archive/0466cac4be1333d0794b01f4726780be23535767.tar.gz",
          # sha256sum = "a8e2e9bcbd04273b4b900a0962ae4296beac5b3617112490f0e88510b3537fcb",

          # uri = "https://github.com/wlrfx/scenefx/archive/026ba4eb9837f1374bd79e1c9b722fb898e91830.tar.gz",
          # sha256sum = "ee7bcb2bb92d1bb0000b2c3da2a2b8ac4aebe96309cb14ea8d19251821cf3be4",

          uri = "https://github.com/wlrfx/scenefx/archive/refs/tags/0.4.1.tar.gz",
          sha256sum  = "fa23f6ff509168d4a5eb0c5a7ef3b8cf3d39e3fba18320c28256e6c91c85d9ff"
        },
      },
      {
        dest = "subprojects/wlroots",
     
        src = {

          uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.0/downloads/wlroots-0.19.0.tar.gz",
          sha256sum = "aefb0fe2633b0aad1d66123b2f41afab004fb625e2a7790492cdd39a805cac91",

          # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/12316417b033465114705430105785e72dfe345d/wlroots-12316417b033465114705430105785e72dfe345d.tar.gz",
          # sha256sum = "48546c2c923901362cd29e525649f7f74ae6d9180968481005b582e932f609d7"
        },
      }
    ],
    buildEnv.EXTRA_LDFLAGS = ["-lc++"],

    extraMesonArgs = [
      "--force-fallback-for=wlroots",
      "-Dwlroots:examples=false",
      "-Dwlroots:backends=drm,libinput,x11",
      "-Dwlroots:xwayland=enabled",
      "-Dwlroots:renderers=gles2",
      "-Dscenefx:examples=false",
      "-Dwlroots:color-management=enabled",
      "-Dgdk-pixbuf=enabled",
      "-Dtray=enabled",
      "-Dman-pages=enabled",
    ],

    preConfigurePhase = [

      m%"
      fix_symbol_wlroots(){
        for f in $(find ${SRC}/subprojects/wlroots -type f);do
          sed -i "s@${1}@${1}_wlroots@g" ${f}
        done
      }
      "%,

      "fix_symbol_wlroots output_pending_resolution",
      "fix_symbol_wlroots wlr_matrix_identity",
      "fix_symbol_wlroots wlr_matrix_multiply",
      "fix_symbol_wlroots wlr_matrix_translate",
      "fix_symbol_wlroots wlr_matrix_scale",
      "fix_symbol_wlroots wlr_matrix_project_box",
      "fix_symbol_wlroots wlr_matrix_transform",
      "fix_symbol_wlroots matrix_invert",
      "fix_symbol_wlroots matrix_projection",
      # m%"
      #   for f in $(find ${SRC}/subprojects/wlroots -type f);do
      #       sed -i 's@output_pending_resolution@output_pending_resolution_wlroots@g' ${f}
      #       sed -i 's@wlr_matrix_identity@wlr_matrix_identity_wlroots@g' ${f}
      #       sed -i 's@wlr_matrix_multiply@wlr_matrix_multiply_wlroots@g' ${f}
      #       sed -i 's@wlr_matrix_translate@wlr_matrix_translate_wlroots@g' ${f}
      #       sed -i 's@wlr_matrix_scale@wlr_matrix_scale_wlroots@g' ${f}
      #       sed -i 's@matrix_projection@matrix_projection_wlroots@g' ${f}
      #   done
      #   "%,
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


      # "sed -i 's@0.20.0-dev@0.19.1@g' ${SRC}/subprojects/wlroots/meson.build",
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
      drvs.eudev,
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
      # drvs.scenefx,

      # for X
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

      # For other optional features
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,
    ],

    buildEnv = {
      EXTRA_CFLAGS = [
        # ../src/sway/server.c:442:54: error: passing arguments to 'animation_manager_create' without a prototype is deprecated in all versions of C and is not supported in C23 [-Werror,-Wdeprecated-non-prototype]
        "-Wno-deprecated-non-prototype",
      ],
    },
  }
}
& {
  lib,
  drvs,
  scenefx | lib.MesonPackage = {
    sourceInputs = [
      # {
      #   src = {
      #     uri = "https://github.com/wlrfx/scenefx/archive/d1323e6c8b3f70de37682ef89dac9d678b2c9964.zip",
      #     sha256sum = "6d9dec7ce390c6e4b85a2ea036bcc0400c72ffbdc9109c03fe9f2a31ace7acc5"
      #   },
      # },
      {
        # dest = "subprojects/scenefx",
        src = {
          #uri = "https://github.com/wlrfx/scenefx/archive/9fad3806102c73c2376114512c185e125d95136b.zip",
          #sha256sum = "94d048b14cd8bac6c0412ef282e52a2e004a9520b88dafba599661a3a53671a5"
          uri = "https://github.com/wlrfx/scenefx/archive/refs/tags/0.2.1.tar.gz",
          sha256sum = "e50cd8cbeb6564233dced39f21e78d755701fa7fe67f5b354f033f397b69a2b8"
        },
      },
      # {
      #   dest = "subprojects/wlroots",
      #   src = {
      #     uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.0/wlroots-0.18.0.tar.gz",
      #     sha256sum = "df347ddbf291d18710bd11d8228a49e7b0eafd88d0d7bbb4215d118374590516"
      #   },
      # }
    ],

    buildEnv.EXTRA_LDFLAGS = ["-lc++"],
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
      drvs.wlroots18,
    ],

    preConfigurePhase = [
      m%"
        for f in $(find ${SRC}/subprojects/wlroots -type f);do
            sed -i 's@output_pending_resolution@output_pending_resolution_wlroots@g' ${f}
            sed -i 's@buffer_is_opaque@buffer_is_opaque_wlroots@g' ${f}
            sed -i 's@matrix_projection@matrix_projection_wlroots@g' ${f}
        done

        sed -i 's@0.18.1@0.18.0@g' ${SRC}/meson.build
        "%
    ]
  }
}
