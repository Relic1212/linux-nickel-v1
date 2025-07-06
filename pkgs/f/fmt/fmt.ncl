{
  lib,

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
    },

    cmakeExtraArgsRecord = {
      "-DFMT_TEST" = false,
    }

    # patches = [{
    #   file = "6e462b89aa22fd5f737ed162d0150e145ccb1914.diff",
    #   sha256sum = "bba32cb1b8ea7bb1ce19513f612be1c4a3ec4b7f8f24d994f40eaf0fd10418f4"
    # }]
  }
}
