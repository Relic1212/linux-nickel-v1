{
  lib,
  drvs,

  hyprlock | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprlock/archive/refs/tags/v0.9.5.tar.gz",
      sha256sum = "cbc49fc5553c550131e1a15089847501de42579944814229bfa9f8ea18519f89",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libjpeg)",
        "$(pkg-config --libs --static libcurl)",
        "$(pkg-config --libs --static libcap)",
        "$(pkg-config --libs --static libwebp)",
        "$(pkg-config --libs --static libmagic)",
      ],
    },
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      # drvs.pixman,
      # drvs.expat,
      # #   drvs.libffi,
      # drvs.libevdev,
      # drvs.mtdev,
      # drvs.pango,
      # drvs.cairo,
      # drvs.libpng,
      # drvs.freetype,
      # drvs.fontconfig,
      # #   drvs.zlibNg,
      # drvs.harfbuzz,
      # drvs.glib,
      # drvs.hwdata,
      #   drvs.linuxHeaders,
      drvs.hyprwaylandScanner,
      # drvs.aquamarine,
      # drvs.hyprutils,
      # drvs.hyprlang,
      # drvs.hyprcursor,
      # drvs.libjpegTurboStatic,
      # drvs.libspng,
      # drvs.file,
      # drvs.libwebp,
      # drvs.fribidi,
      # drvs.pcre2,
    ],

    pDrvs = [
      drvs.sdbusCpp,
      # drvs.mesa2,
      drvs.howardHinnantDate,
      drvs.hyprgraphics,
      drvs.libxkbcommon,
    ],
  }
}
