{
  lib,
  drvs,
  ananicyCpp | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      #   uri = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/archive/v1.0.1/ananicy-cpp-v1.0.1.tar.bz2",
      #   sha256sum = "65219a03a2b9dfc417d7dcf99955d3b866296b148b55532ab1323900c1567ad1",

      uri = "https://gitlab.com/ananicy-cpp/ananicy-cpp/-/archive/v1.1.1/ananicy-cpp-v1.1.1.tar.bz2",
      sha256sum = "575c543491e3d0574a97e1fe132fb7a6fddfb9dab93d126dedf1fce0ff0329e8"
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gitlab.com/vnepogodin/std-format/-/archive/dfa4fdc87c7cb9bb1683125009baa7278bb85901/std-format-dfa4fdc87c7cb9bb1683125009baa7278bb85901.tar.bz2",
          sha256sum = "6f89fd11731d3cd5fd70cd68ea1813828cfac3a07378f5660b3e0a2ecebd89f7"
        },
        dest = "external/std-format"
      },
      #   {
      #     src = {
      #       uri = "https://github.com/fmtlib/fmt/archive/refs/tags/12.1.0.tar.gz",
      #       sha256sum = "ea7de4299689e12b6dddd392f9896f08fb0777ac7168897a244a6d6085043fea",          
      #       uri = "https://github.com/fmtlib/fmt/archive/refs/tags/9.1.0.tar.gz",
      #       sha256sum = "5dea48d1fcddc3ec571ce2058e13910a0d4a6bab4cc09a809d8b1dd1c88ae6f2",
      #     },
      #     dest = "external/fmt"
      #   },
    ],

    patches = [
      {
        sha256sum = "5feaba99fa1c21cc016715d9a13dfab3c1c6421ffcd4823f0a2a923b5d98d1ca",

        file = "ananicy-cpp.patch",
      }
    ],

    cmakeExtraArgsRecord = {
      "-DUSE_EXTERNAL_JSON" = true,
      "-DUSE_EXTERNAL_FMTLIB" = true,
      "-DUSE_EXTERNAL_SPDLOG" = true,
      "-DENABLE_SYSTEMD" = false,
      "-DSTATIC" = true,
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lspdlog"
      ]
    },

    biDrvs = [
      drvs.spdlog,
      drvs.fmt,
      drvs.nlohmannJsonCmake,
      drvs.linuxHeaders,
    ]
  },

  ananicyRulesCachyos | lib.Package = {
    singleSource = {
      uri = "https://github.com/CachyOS/ananicy-rules/archive/refs/tags/1.1.6.tar.gz",
      sha256sum = "cc11d213320ee358734f91b10ad3c1e9570e248c10061f7f28fddbd3af32f1f6"
    },
    separateBuildDir = false,
    installPhase = [
      "install -dm0755 ${DEST}/etc/ananicy.d",
      "cp -r * ${DEST}/etc/ananicy.d",
    ]
  }
}
