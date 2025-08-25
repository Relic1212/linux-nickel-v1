{
  lib,
  drvs,
  mesaDemos | lib.MesonPackage = {
    singleSource = {
      uri = "https://archive.mesa3d.org/demos/mesa-demos-9.0.0.tar.xz",
      sha256sum = "3046a3d26a7b051af7ebdd257a5f23bfeb160cad6ed952329cdff1e9f1ed496b",

      # uri = "https://gitlab.freedesktop.org/mesa/demos/-/archive/d5d06d4c573a65230229831cb7d35e1d563f1829/demos-d5d06d4c573a65230229831cb7d35e1d563f1829.tar.gz",
      # sha256sum = "b34c18979598d25ed4f2c1f9c63e717e13ddf0c7d24fd0e4d6d9fbfcffd9cbd7",

      # uri = "https://gitlab.freedesktop.org/mesa/demos/-/archive/e374da37adc530ede6229997565dd54e34a542fa/demos-e374da37adc530ede6229997565dd54e34a542fa.tar.gz",
      # sha256sum = "2cf3e9cec13cd925be697f52f660094906e9cb5395b480b7b265e7d212e7b1e0"
    },

    options = {
      glx | default = false,
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },
    baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,

    extraMesonArgs =
      if options.glx then
        [
          "-Dx11=enabled",
        ]
      else
        [
          "-Dgles1=disabled",
          "-Dx11=disabled",
          "-Dglut=disabled",
        ],

    biDrvs =
      [
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        # drvs.wayland,
        # drvs.waylandProtocols,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmFull,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.glu,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.cairo,
        drvs.glib,
        drvs.pcre2,
        drvs.harfbuzz,
        drvs.pango,
        drvs.libdecor,
      ]
      @ (
        if options.glx then
          [
            drvs.mesaGlx,
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
            drvs.xcbUtilErrors,
            drvs.libxext,
            drvs.libxf86vm,
            drvs.libxrandr,
            drvs.glxSymlink,
          ]
        else
          [
            drvs.mesa2,
          ]
      ),
  },
  mesaDemosGlx = mesaDemos & { options.glx = true },
}
& (
  let glu_src = { uri = "https://archive.mesa3d.org/glu/glu-9.0.3.tar.xz", sha256sum = "bd43fe12f374b1192eb15fe20e45ff456b9bc26ab57f0eee919f96ca0f8a330f" } in

  {
    lib,
    drvs,
    glu | lib.MesonPackage = {
      singleSource = glu_src,

      options = {
        glx | default = true,
      },
      extraMesonArgs = [
        "-Dgl_provider=gl"
      ],

      biDrvs =
        [
          drvs.libelf,
          drvs.libdrm,
          drvs.zlibNg,
          drvs.pythonMako,
          drvs.pythonPackaging,
          drvs.pythonMarkupsafe,
          drvs.libpciaccess,
          drvs.libffi,
          drvs.bison,
          drvs.flex,
          # drvs.wayland,
          # drvs.waylandProtocols,
          drvs.linuxHeaders,
          drvs.m4,
          drvs.git,
          drvs.pyyaml,
          drvs.llvmFull,
          drvs.llvmConfigStatic,
          drvs.spirvTools,
          drvs.spirvLlvmTranslator,
          drvs.wayland,
          drvs.waylandProtocols,
        ]
        @ (
          if options.glx then
            [
              drvs.mesaGlx,
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
              drvs.xcbUtilErrors,
              drvs.libxext,
              drvs.libxf86vm,
              drvs.libxrandr,
            ]
          else
            [
              drvs.mesa2,
            ]
        ),
    }
  }
)
& {
  lib,
  drvs,
  glxSymlink | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s egl.pc glx.pc",
    ]
  }
}
& {
  lib,
  drvs,
  libdecor | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/libdecor/libdecor/-/releases/0.2.3/downloads/libdecor-0.2.3.tar.xz",
      sha256sum = "66ab953da968eb2c24c27a8641fdb00d3a6e64c3cf8780c67c14e3202698b39c"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },

    options = {
      glx | default = true,
    },

    extraMesonArgs = [
      "-Dgtk=disabled",
      "-Ddbus=disabled",
      "-Ddemo=false",
    ],
    preConfigurePhase = [
      m%"sed -i "s@subdir('plugins')@@g" ${SRC}/src/meson.build"%,
      m%"sed -i "s@shared_library@library@g" ${SRC}/src/meson.build"%,
    ],

    biDrvs =
      [
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        # drvs.wayland,
        # drvs.waylandProtocols,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmFull,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.dbus,
        drvs.pixman,
        drvs.freetype,
        drvs.fontconfig,
        drvs.libpng,
        drvs.expat,
        drvs.cairo,
        drvs.glib,
        drvs.pcre2,
        drvs.harfbuzz,
        drvs.pango,
      ]
      @ (
        if options.glx then
          [
            drvs.mesaGlx,
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
            drvs.xcbUtilErrors,
            drvs.libxext,
            drvs.libxf86vm,
            drvs.libxrandr,
          ]
        else
          [
            drvs.mesa2,
          ]
      ),
  }
}
