{
  lib,
  drvs,
  spirvTools,
  spirvHeaders,
  glslang,
  shaderc | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/shaderc/archive/refs/tags/v2025.5.tar.gz",
      sha256sum = "fca5041b1fdea6daba167b63e04e55e5059fab40828342126169336643445447",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = (std.array.at 0 spirvTools.sourceInputs).src,
        dest = "third_party/spirv-tools"
      },
      {
        src = spirvHeaders.singleSource,
        dest = "third_party/spirv-tools/external/spirv-headers"
      },
      {
        src = glslang.singleSource,
        dest = "third_party/glslang"
      },
    ],
    extraFiles = [
      {
        file = "0001-no-shared.patch",
        sha256sum = "0622acd34f987e45dfba87f6d9cd33c4356cb1476a8baa6c63dd8f5e9fe9391b",
      }
    ],
    cmakeExtraArgsRecord = {
      "-DSHADERC_SKIP_TESTS" = true,
    },
    preConfigurePhase = [
      m%"sed -i 's| SHARED | |g' ${SRC}/libshaderc/CMakeLists.txt"%,
      "(cd ${SRC}/third_party/spirv-tools && patch -p1 < /tmp/workdir/files/0001-no-shared.patch)"
    ],
    biDrvs = [
      drvs.pythonFull,
      drvs.googletest,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.glslang,
    ],
  }
}
