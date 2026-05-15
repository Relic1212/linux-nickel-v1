{
  lib,
  drvs,
  hyprlauncher | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprlauncher/archive/refs/tags/v0.1.6.tar.gz",
      sha256sum = "f02f93584e1017d7a466d0cafed910f630be39eba6b433922e645c834c4abf59",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--error-limit=0",
        "$(pkg-config --libs --static glesv2 aquamarine iniparser libseat libudev egl xkbcommon libdisplay-info hyprgraphics libinput cairo libpng libjpeg pango libwebp pangocairo libmagic)",
      ],
    },
    options.glx = false,
    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.hyprtoolkit,
      drvs.hyprwire,
      # drvs.libicu,
      drvs.libqalculate,
      # drvs.pango,
    ]
  }
}
