{
  lib,
  drvs,
  libbpf | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.2.tar.gz",
      sha256sum = "16f31349c70764cba8e0fad3725cc9f52f6cf952554326aa0229daaa21ef4fbd"
    },
    cdBuildPhase | priority 1 = [
      "cd ${SRC}/src",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libelf,
      drvs.zlibNg,
    ],
    extraEnv = {
      BUILD_STATIC_ONLY = "y"
    },
    extraMakeArgs = [
      "LIBDIR=/usr/lib",
      "LIBSUBDIR=lib",
    ],
    extraMakeInstallArgs = extraMakeArgs,
  }
}
