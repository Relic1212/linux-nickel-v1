{
  lib,
  drvs,

  cage | lib.MesonPackage = {

    sourceInputs = [
      {
        src = {
          uri = "https://github.com/cage-kiosk/cage/archive/refs/tags/v0.2.0.tar.gz",
          sha256sum = "9d3f659e0f19636a958f9e1bf4d22268d7e2705d7e2989888401ec443c1cb6c3",
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
  cagebreak | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/project-repo/cagebreak/archive/refs/tags/2.4.0.tar.gz",
      sha256sum = "5c2d1688a231dd1a311143aa595637078d2161789c735aad994622a021f84e6f"
    },

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

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },
  }
}
