{
  lib,
  drvs,
  swayfx | lib.MesonPackage
    = {
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/WillPower3309/swayfx/archive/3e4b6b75f4b42b4cb04d883033b04b4a1b57bc90.zip",
            sha256sum = "2832e634289fed59d5d2b9b14c4d1c5580375e591a0f006951b8e2c5fa9bd03b"
          }
        },
        # {
        #   dest = "subprojects/scenefx",
        #   src = {
        #     uri = "https://github.com/wlrfx/scenefx/archive/9fad3806102c73c2376114512c185e125d95136b.zip",
        #     sha256sum = "94d048b14cd8bac6c0412ef282e52a2e004a9520b88dafba599661a3a53671a5"
        #   },
        # },
        {
          dest = "subprojects/wlroots",
          src = {
            uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.0/wlroots-0.18.0.tar.gz",
            sha256sum = "df347ddbf291d18710bd11d8228a49e7b0eafd88d0d7bbb4215d118374590516"
          },
        }
      ],
      buildEnv.EXTRA_LDFLAGS = ["-lc++"],

      extraMesonArgs = [
        "--force-fallback-for=wlroots"
      ],

      preConfigurePhase = [
        m%"
        for f in $(find ${SRC}/subprojects/wlroots -type f);do
            sed -i 's@output_pending_resolution@output_pending_resolution_wlroots@g' ${f}
            sed -i 's@buffer_is_opaque@buffer_is_opaque_wlroots@g' ${f}
            sed -i 's@matrix_projection@matrix_projection_wlroots@g' ${f}
        done
        "%
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
        drvs.scenefx,
      ]
    }
}
& {
  lib,
  drvs,
  scenefx | lib.MesonPackage
    = {
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
            uri = "https://github.com/wlrfx/scenefx/archive/9fad3806102c73c2376114512c185e125d95136b.zip",
            sha256sum = "94d048b14cd8bac6c0412ef282e52a2e004a9520b88dafba599661a3a53671a5"
          },
        },
        {
          dest = "subprojects/wlroots",
          src = {
            uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.0/wlroots-0.18.0.tar.gz",
            sha256sum = "df347ddbf291d18710bd11d8228a49e7b0eafd88d0d7bbb4215d118374590516"
          },
        }
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
        # drvs."wlroots-18",
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
