{
  lib,
  drvs,
  spiceVdagent | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.spice-space.org/download/releases/spice-vdagent-0.22.0.tar.bz2",
      sha256sum = "553597a2ee3dcecd687db3fd92c6b6bb460260a53879d914ae9619ce81a8fb93",
    },
    buildEnv = {
      EXTRA_CFLAGS = [
        # "$(pkg-config --cflags gtk+-3.0)",
      ],
      EXTRA_CPPFLAGS = EXTRA_CFLAGS,
    },
    extraConfigureFlags = [
      "--with-gtk4=yes",
      "--with-gtk=no",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.gtk3X11,
    ],
    neverInclude = [
      drvs.gtk3,
    ],
    pDrvs = [
      drvs.gtk4X11,
      #   drvs.libxrandr,
      #   drvs.libxinerama,
      # drvs.libx11,
      #   drvs.libxfixes,
      drvs.spiceProtocol,
      drvs.alsaLibs,
      #   drvs.libxi,
      #   drvs.cairoXlib,
      # drvs.libxcursor,
    ],
  }
}
