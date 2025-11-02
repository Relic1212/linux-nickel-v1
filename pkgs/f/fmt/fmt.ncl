{
  lib,
  drvs,
  fmt | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/fmtlib/fmt/archive/df249d8ad3a9375f54919bdfa10a33ae5cba99a2.zip",
      # sha256sum = "703a9eeb5282b105e739e7d47b4c4844ef030d2c58732dc70f9a225fc79051db"

      # uri = "https://github.com/fmtlib/fmt/archive/6e462b89aa22fd5f737ed162d0150e145ccb1914.zip",
      # sha256sum = "b2a1b1ddf272b1c8836a46412677fa5918c76732c07baf23c768f06968a49782"

      # uri = "https://github.com/fmtlib/fmt/archive/refs/tags/10.2.1.tar.gz",
      # sha256sum = "1250e4cc58bf06ee631567523f48848dc4596133e163f02615c97f78bab6c811"

      uri = "https://github.com/fmtlib/fmt/archive/refs/tags/11.1.4.tar.gz",
      sha256sum = "ac366b7b4c2e9f0dde63a59b3feb5ee59b67974b14ee5dc9ea8ad78aa2c1ee1e",

      # uri = "https://github.com/fmtlib/fmt/archive/refs/tags/12.1.0.tar.gz",
      # sha256sum = "ea7de4299689e12b6dddd392f9896f08fb0777ac7168897a244a6d6085043fea",

      # uri = "https://github.com/fmtlib/fmt/archive/refs/tags/11.0.1.tar.gz",
      # sha256sum = "7d009f7f89ac84c0a83f79ed602463d092fbf66763766a907c97fd02b100f5e9",
    },

    cmakeExtraArgsRecord = {
      "-DFMT_TEST" = false,
    },
    preConfigurePhase = [
      # https://github.com/fmtlib/fmt/pull/4477/files
      m%"sed -i 's|#  include <cstring>|#  include <cstdlib>\n#  include <cstring>|g' ${SRC}/include/fmt/format.h"%,
      m%"sed -i 's|malloc|std::malloc|g' ${SRC}/include/fmt/format.h"%,
    ],

    # patches = [{
    #   file = "6e462b89aa22fd5f737ed162d0150e145ccb1914.diff",
    #   sha256sum = "bba32cb1b8ea7bb1ce19513f612be1c4a3ec4b7f8f24d994f40eaf0fd10418f4"
    # }]
  }
}
