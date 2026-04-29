{
  lib,
  drvs,
  sdbusCpp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/Kistler-Group/sdbus-cpp/archive/refs/tags/v2.2.1.tar.gz",
      sha256sum = "da69a0104beb6e51415a59f1571a47beb1eacc65cc6027b250eb1cf13ff4f802",
    },
    propagatedBuildInputs = [
      drvs.elogindWithPolkit,
    ],
  }
}
