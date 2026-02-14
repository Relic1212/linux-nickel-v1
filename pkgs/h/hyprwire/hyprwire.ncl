{
  lib,
  drvs,
  hyprwire | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/hyprwm/hyprwire/archive/refs/tags/v0.3.0.tar.gz",
      sha256sum = "ba3ff4b82620209d5680ce0e771d0f2c41f78cdb96d5d84fa66e4f0709ca8de6",
    },
    cmakeExtraArgsRecord = {
      "-DBUILD_TESTING" = false,
    },
    preConfigurePhase = [
      "sed -i 's|SHARED|STATIC|g' ${SRC}/CMakeLists.txt",
    ],
    biDrvs = [
      drvs.pugixml,
      drvs.hyprutils,
      drvs.libffi,
    ]
  }
}
