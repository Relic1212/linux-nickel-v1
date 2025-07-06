{
  lib,
  expat,
  jsonC,
  pcre2,
  mesa2,
  wayland,
  waylandProtocols,
  libelf,
  libpciaccess,
  libdrm,
  libxkbcommon,
  pixman,
  eudev,
  libudevZero,
  seatd,
  libdisplayinfo,
  libinput,
  libffi,
  libevdev,
  mtdev,
  pango,
  cairo,
  libpng,
  freetype,
  fontconfig,
  zlibNg,
  harfbuzz,
  glib,
  hwdata,
  linuxHeaders,
  scenefx,
  libxcursor,
  xorgMacros,
  xorgproto,
  xtrans,
  libxcb,
  xcbProto,
  libxau,
  libx11,
  libxrender,
  libxfixes,
  xcbRenderutil,
  libxfont2,
  libfontenc,
  libxcvt,
  libxshmfence,
  xwayland,
  libxkbfile,
  openssl,
  xcbUtilWm,
  gdkPixbufFull,
  libjpegTurbo,
  basu,
  lcms,
  scdoc,
  llvmFull,

  swayfx | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/WillPower3309/swayfx/archive/e8c689c2691f99b7ee883f1003c2f913575af5aa.tar.gz",
          sha256sum = "204d2c19ed5744d3f27af1165d84dc7d58c8d1a2db3366154ef3a1fa3df9e137"
        }
      },
      {
        dest = "subprojects/scenefx",
        src = {
          uri = "https://github.com/wlrfx/scenefx/archive/7289eeec8239849385b87f127aae8fe0bd82b8e4.tar.gz",
          sha256sum = "c0f5aca87102254f6670d30255a1a16fb76494f57fb3ac80246bd0cffe974824"
        },
      },
      {
        dest = "subprojects/wlroots",
        # src = {
        #   uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.0/wlroots-0.18.0.tar.gz",
        #   sha256sum = "df347ddbf291d18710bd11d8228a49e7b0eafd88d0d7bbb4215d118374590516"
        # },
        src = {
          uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.2/wlroots-0.18.2.tar.gz",
          sha256sum = "703c515917d9eb258e44296795f8626190e119b0ee8bfb32fe9f834dab1a1462"
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
        for f in $(find ${SRC}/subprojects/wlroots -type f);do
            sed -i 's@output_pending_resolution@output_pending_resolution_wlroots@g' ${f}
            sed -i 's@buffer_is_opaque@buffer_is_opaque_wlroots@g' ${f}
            sed -i 's@matrix_projection@matrix_projection_wlroots@g' ${f}
        done
        "%,
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
    ],

    llvmProvider = lib.singleBiMap llvmFull,
    biDrvs =
      lib.biMap [
        expat,
        jsonC,
        pcre2,
        mesa2,
        wayland,
        waylandProtocols,
        libelf,
        libpciaccess,
        libdrm,
        libxkbcommon,
        pixman,
        eudev,
        libudevZero,
        seatd,
        libdisplayinfo,
        libinput,
        libffi,
        libevdev,
        mtdev,
        pango,
        cairo,
        libpng,
        freetype,
        fontconfig,
        zlibNg,
        harfbuzz,
        glib,
        hwdata,
        linuxHeaders,
        # scenefx,

        # for X
        libxcursor,
        xorgMacros,
        xorgproto,
        xtrans,
        libxcb,
        xcbProto,
        libxau,
        libx11,
        libxrender,
        libxfixes,
        xcbRenderutil,
        libxfont2,
        libfontenc,
        libxcvt,
        libxshmfence,
        xwayland,
        libxkbfile,
        openssl,
        xcbUtilWm,

        # For other optional features
        gdkPixbufFull,
        libjpegTurbo,
        basu,
        lcms,
        scdoc,
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
  expat,
  jsonC,
  pcre2,
  mesa2,
  wayland,
  waylandProtocols,
  libelf,
  libpciaccess,
  libdrm,
  libxkbcommon,
  pixman,
  eudev,
  libudevZero,
  seatd,
  libdisplayinfo,
  libinput,
  libffi,
  libevdev,
  mtdev,
  pango,
  cairo,
  libpng,
  freetype,
  fontconfig,
  zlibNg,
  harfbuzz,
  glib,
  hwdata,
  linuxHeaders,
  wlroots18,
  llvmFull,

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
    llvmProvider = lib.singleBiMap llvmFull,
    biDrvs =
      lib.biMap [
        expat,
        jsonC,
        pcre2,
        mesa2,
        wayland,
        waylandProtocols,
        libelf,
        libpciaccess,
        libdrm,
        libxkbcommon,
        pixman,
        # eudev,
        libudevZero,
        seatd,
        libdisplayinfo,
        libinput,
        libffi,
        libevdev,
        mtdev,
        pango,
        cairo,
        libpng,
        freetype,
        fontconfig,
        zlibNg,
        harfbuzz,
        glib,
        hwdata,
        linuxHeaders,
        wlroots18,
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
