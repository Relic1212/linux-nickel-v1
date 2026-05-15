{
  lib,
  drvs,
  hyprtoolkit | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/hyprwm/hyprtoolkit/archive/refs/tags/v0.5.4.tar.gz",
      sha256sum = "2fb59789f231c1c4e9154ceffc1e7524c0cae154807c0d57e6166806255b570f",
    },
    generator = "Ninja",
    preConfigurePhase = [
      "sed -i 's@OpenGL::OpenGL@OpenGL::GLES2@g' ${SRC}/CMakeLists.txt",
      "sed -i 's@SHARED@STATIC@g' ${SRC}/CMakeLists.txt",
    ],

    options.glx = false,
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.hyprwaylandScanner,
    ],
    pDrvs = [
      drvs.hyprgraphics,
      drvs.libxkbcommon,
      drvs.iniparser,
    ]
  },
}
