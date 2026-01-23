{
  lib,
  drvs,
  gn | lib.Package = {
    singleSource = {
      uri = "https://gn.googlesource.com/gn.git",
      sha256sum = "64d35867ca0a1088f13de8f4ccaf1a5687d7f1ce"
    },
    separateBuildDir = false,
    configurePhase = [
      "python build/gen.py"
    ],
    buildPhase = [
      "ninja -C out"
    ],
    installPhase = [
      # "install -Dm0755 ${DEST}/usr/bin",
      "install -Dm0755 out/gn ${DEST}/usr/bin/gn",
    ],
    muslProvider,
    biDrvs = [
      drvs.samurai,
      drvs.pythonFull,
      muslProvider,
      drvs.git,
      drvs.llvm,
      drvs.ccacheBin,
    ]
  }
}
