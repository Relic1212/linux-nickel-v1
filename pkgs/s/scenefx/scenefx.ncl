{
  lib,
  drvs,

  scenefx | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/wlrfx/scenefx/archive/refs/tags/0.5.tar.gz",
      sha256sum = "0fa8ecca0e310f813efd052624c5ed7d9153d6a0fdead5cc957d34c07f9a86c6",
    },
    extraMesonArgs = [
      "-Drenderers=gles2",
      "-Dexamples=false",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.scdoc,
    ],
    propagatedBuildInputs = [
      drvs.wlroots20,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.lcms,
    ],
  },

  scenefx041 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/wlrfx/scenefx/archive/refs/tags/0.4.1.tar.gz",
      sha256sum = "fa23f6ff509168d4a5eb0c5a7ef3b8cf3d39e3fba18320c28256e6c91c85d9ff",
    },
    extraMesonArgs = [
      "-Drenderers=gles2",
      "-Dexamples=false",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.scdoc,
    ],
    propagatedBuildInputs = [
      drvs.wlroots19,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.lcms,
    ],
  },
}
& {
  lib,
  drvs,
  scenefx021 | lib.MesonPackage = {
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
      drvs.wlroots18,
      drvs.spirvTools,
    ],

    propagatedBuildInputs = [
      drvs.seatd,
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
