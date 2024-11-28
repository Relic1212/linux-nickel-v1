{
  drvs,
  lib,

  libepoxy | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/anholt/libepoxy/archive/refs/tags/1.5.10.tar.gz",
        sha256sum = "a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15"
      },
      buildEnv = {
        EXTRA_LDFLAGS = ["-lc++"],
      },
      extraMesonArgs = [
        "-Dglx=no",
        "-Degl=yes",
        "-Dx11=false",
        "-Ddocs=false",
        "-Dtests=false",
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
    }
}
