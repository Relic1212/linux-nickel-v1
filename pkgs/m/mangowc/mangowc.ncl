{
  lib,
  drvs,
  mangowc | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/DreamMaoMao/mangowc/archive/refs/tags/0.10.5.tar.gz",
      # sha256sum = "2658454c120cc2d88d25bd105e58337204a84f9e1d418b41ff02983d1354e9ef",

      uri = "https://github.com/mangowm/mango/archive/refs/tags/0.12.7.tar.gz",
      sha256sum = "35bbe111ae27763350b567b2d67e750517d788ec4b4163074267cc564e64642e",
    },

    # sourceInputs = [
    #   {
    #     src = singleSource
    #   },
    #   {
    #     src = {
    #       uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.19.2/wlroots-0.19.2.tar.bz2",
    #       sha256sum = "804bd3eab10f03556628c4e977351b0b1b17bc34084342dfaff5086c54ce1fa0",
    #     },
    #     dest = "subprojects/wlroots"
    #   },
    #   {
    #     src = {
    #       uri = "https://github.com/wlrfx/scenefx/archive/refs/tags/0.4.1.tar.gz",
    #       sha256sum = "fa23f6ff509168d4a5eb0c5a7ef3b8cf3d39e3fba18320c28256e6c91c85d9ff",
    #     },
    #     dest = "subprojects/scenefx"
    #   },
    # ],

    patches = [
      {
        sha256sum = "1d64a3b2a814a2c8a1988c2d05c17962f18921448e530dca38a530d38191ebbb",
        file = "mangowc-chvt-2.patch"
      }
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },
    extraMesonArgs = [
      "-Dxwayland=disabled",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.expat,
      drvs.jsonC,
      drvs.pcre2,
      drvs.mesa2,
      drvs.spirvTools,
      drvs.wayland,
      #drvs.waylandProtocols_1_41,
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
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,
      #   drvs.libxcursor,
      #   drvs.xorgMacros,
      #   drvs.xorgproto,
      #   drvs.xtrans,
      #   drvs.libxcb,
      #   drvs.xcbProto,
      #   drvs.libxau,
      #   drvs.libx11,
      #   drvs.libxrender,
      #   drvs.libxfixes,
      #   drvs.xcbRenderutil,
      #   drvs.libxfont2,
      #   drvs.libfontenc,
      #   drvs.libxcvt,
      #   drvs.libxshmfence,
      #   drvs.xwayland,
      #   drvs.libxkbfile,
      #   drvs.openssl,
      #   drvs.xcbUtilWm,
      drvs.wlroots19,
      drvs.scenefx041,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
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
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.basu,
      drvs.lcms,
      drvs.scdoc,
      #   drvs.libxcursor,
      #   drvs.xorgMacros,
      #   drvs.xorgproto,
      #   drvs.xtrans,
      #   drvs.libxcb,
      #   drvs.xcbProto,
      #   drvs.libxau,
      #   drvs.libx11,
      #   drvs.libxrender,
      #   drvs.libxfixes,
      #   drvs.xcbRenderutil,
      #   drvs.libxfont2,
      #   drvs.libfontenc,
      #   drvs.libxcvt,
      #   drvs.libxshmfence,
      #   drvs.xwayland,
      #   drvs.libxkbfile,
      drvs.openssl,
      drvs.xcbUtilWm,
      drvs.wlroots19,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
    ],
  },

  wlroots20 | lib.MesonPackage =
    wlroots19
    & {
      singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.20.0/wlroots-0.20.0.tar.bz2",
        sha256sum = "acb7714cf3853cf6f8f500af35fa5df140fbad2fe9403e978609cf9d0b50b3b4",
      },
      preConfigurePhase = [
        m%"sed -i 's|129|128|g' ${SRC}/meson.build"%, # libdrm
        m%"sed -i 's|0.46.0|0.43.0|g' ${SRC}/render/pixman/meson.build"%, # pixman
      ],
      postInstallPhase | priority 1 = [
        "(cd ${DEST}/usr/include && ln -s wlroots-0.20/wlr wlr)",
      ],
    },

  wlroots19 | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.19.2/wlroots-0.19.2.tar.bz2",
      sha256sum = "804bd3eab10f03556628c4e977351b0b1b17bc34084342dfaff5086c54ce1fa0",
    },
    extraMesonArgs = [
      "-Dxwayland=%{ if options.xwayland then "enabled" else "disabled" }",
      "-Dbackends=drm,libinput%{if options.xwayland then ",x11" else ""}",
      "-Dwlroots:color-management=enabled",
      "-Drenderers=gles2",
      "-Dexamples=false",
      "-Drenderers=gles2",
      #   "-Dcolor-management=disabled",
    ],

    options = {
      xwayland | default = false,
    },

    postInstallPhase =
      let symbols = [
        "matrix_projection",
        "buffer_is_opaque",
        "output_pending_resolution",
      ]
      in
      std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libwlroots-0.19.a") symbols,

    llvmProvider = drvs.llvmFull,
    biDrvs =
      [
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
        drvs.gdkPixbufFull,
        drvs.libjpegTurbo,
        drvs.basu,
        drvs.lcms,
        drvs.scdoc,
        drvs.openssl,
        drvs.xcbUtilWm,
      ]
      @ (
        if options.xwayland then
          [
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
          ]
        else
          []
      ),
    propagatedBuildInputs = [
      drvs.seatd,
    ],
  },
  wlroots19xwayland =
    wlroots19
    & {
      options.xwayland = true,
    }
}
