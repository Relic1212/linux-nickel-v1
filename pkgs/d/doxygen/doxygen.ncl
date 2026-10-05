{
  lib,
  drvs,
  doxygen | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/doxygen/doxygen/archive/refs/tags/Release_1_18_0.tar.gz",
      sha256sum = "b32a3def78b0b75a2fd74ee6a63fb4a79cb6273fe31a570362e4e1871fa446da",
    },
    cmakeExtraArgsRecord = {
      "-Duse_sys_spdlog" = true,
      "-Duse_sys_fmt" = true,
    },

    preConfigurePhase = [
      m%"sed -i 's@CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE@CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE@g' ${SRC}/CMakeLists.txt"%,
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.flex,
      drvs.m4,
      drvs.bison,
    ],
    pDrvs = [
      drvs.spdlog,
      drvs.fmt,
    ],
  }
}
