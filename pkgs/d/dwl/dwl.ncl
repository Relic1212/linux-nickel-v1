{
  lib,
  drvs,

  dwl | lib.MakePackage = {

    sourceInputs = [
      {
        src = {
          uri = "https://codeberg.org/dwl/dwl/archive/v0.7.tar.gz",
          sha256sum = "401a572462fa89f6adf0d0cfe58d909ef334a2c7cd1357db86ec70f32bd4b4d3",
        }
      },
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
      drvs.pkgconfMeson,
      drvs.spirvTools,
    ],

    propagatedBuildInputs = [
      drvs.seatd,
    ],

    extraMakeArgs = [
      "CC=clang",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
        "-lcap",
      ],
    },
  }
}
& {
  lib,
  drvs,
  wlroots | lib.MesonPackage = {

    singleSource = {
      uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/e8e76dc2954e1bc4cfe6bbf104996a932b9eb807/wlroots-e8e76dc2954e1bc4cfe6bbf104996a932b9eb807.tar.gz",
      sha256sum = "f89797791f20e14df8319acdfa68e57002fb85efc5977bf22ae9b45fe7583e5d"
    },

    extraMesonArgs = [
      "-Dbackends=drm,libinput"
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
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },
  }
}
& {
  lib,
  drvs,

  wlroots18 | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.1/wlroots-0.18.1.tar.gz",
      # sha256sum = "10084bba57bf4162cd81eb79c2a0bee0d02c7ccd747eac0a7021b45b10bb821c"
      uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.18.2/wlroots-0.18.2.tar.gz",
      sha256sum = "703c515917d9eb258e44296795f8626190e119b0ee8bfb32fe9f834dab1a1462"
    },

    extraMesonArgs = [
      "-Dbackends=drm,libinput",
      "-Drenderers=gles2",
      "-Dsession=enabled",
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
      # drvs.libudevZero,
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
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
    ],
    propagatedBuildInputs = [
      drvs.seatd,
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },

    postInstallPhase =
      let symbols = [
        "matrix_projection",
        "buffer_is_opaque",
        "output_pending_resolution",
      ]
      in
      std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libwlroots-0.18.a") symbols,
  }
}
