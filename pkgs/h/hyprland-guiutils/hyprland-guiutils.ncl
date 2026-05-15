{
  lib,
  drvs,
  hyprlandGuiutils | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprland-guiutils/archive/a968d211048e3ed538e47b84cb3649299578f19d.tar.gz",
      sha256sum = "158c0213920d1d373fab84672ea2c113cdcc10b4346f5e2a482c0d66f2d7a03a",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--error-limit=0",
        "$(pkg-config --libs --static glesv2 aquamarine iniparser libseat libudev egl xkbcommon libdisplay-info hyprgraphics libinput cairo libpng libjpeg pango libwebp pangocairo libmagic)",
      ],
    },

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
