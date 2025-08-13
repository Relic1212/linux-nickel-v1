{
  lib,
  drvs,
  gamescope
    | lib.MesonPackage
    = {

      sourceInputs = [
        {
          src = {

            uri = "https://github.com/ValveSoftware/gamescope/archive/refs/tags/3.16.14.2.tar.gz",
            sha256sum = "b45f38c26d12a630917e812623b9e64e3ff44c3d9f7e9a9c49a73d5372896685"
          }
        },
        {
          src = {

            # uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.18.2/downloads/wlroots-0.18.2.tar.gz",
            # sha256sum = "cf776c169169f279808d9eabc6583f484338dcd454c966a285ff178c88c105d4",

            uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.19.0/downloads/wlroots-0.19.0.tar.gz",
            sha256sum = "aefb0fe2633b0aad1d66123b2f41afab004fb625e2a7790492cdd39a805cac91",
          },
          dest = "subprojects/wlroots"
        }
      ],
      buildEnv.EXTRA_LDFLAGS = ["-lc++"],

      llvmProvider = drvs.llvmFull,

      biDrvs = [
        drvs.expat,
        drvs.jsonC,
        drvs.pcre2,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libelf,
        drvs.libpciaccess,
        drvs.libdrm,
        drvs.libxkbcommon,
        drvs.pixman,
        drvs.eudev,
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
        #  drvs.cmake,
        drvs.utilLinux,
        ###############################################################

        ###############################################################
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
        ###################################################
        drvs.git,
        drvs.libzip,
        drvs.spirvTools,
        drvs.mesaGlx,
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
      ]
    },
}
