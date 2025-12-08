{
  lib,
  drvs,
  waylandProtocols,
  wlrProtocols,
  wlMirror | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/Ferdi265/wl-mirror/archive/refs/tags/v0.18.3.tar.gz",
      sha256sum = "db503683c635bdb5fd97674d31c114630da45f70ddb32484212dd7999ce21be6"
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },
    cmakeExtraArgsRecord = {
      "-DINSTALL_DOCUMENTATION" = true,
      "-DWITH_LIBDECOR" = true,
      "-DWITH_GBM" = true,
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.libelf,
      drvs.libdrm,
      drvs.zlibNg,
      drvs.libpciaccess,
      drvs.libffi,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvHeaders,
      drvs.spirvLlvmTranslator,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.mesa2,
      drvs.scdoc,
      drvs.wlrProtocols,
      drvs.libdecor,
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
  }
}
