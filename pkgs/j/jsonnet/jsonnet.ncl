{
  lib,
  googletest,
  nlohmannJsonCmake,

  jsonnet | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/jsonnet/archive/refs/tags/v0.21.0-rc2.tar.gz",
      sha256sum = "15a91b0b95c847357ab39188f7645980c661204279204129c082339266dcce93"
    },
    patches = [
      {
        sha256sum = "d76873dbfee5352fb34b4a5ee56513a4a9f3a14c719d992c1d241c47db1a693b",

        file = "no-shared.patch",
      }
    ],
    biDrvs =
      lib.biMap [
        googletest,
        nlohmannJsonCmake,
      ],
    cmakeExtraArgsRecord = {
      "-DUSE_SYSTEM_JSON" = true,

      "-DUSE_SYSTEM_GTEST" = true,

      "-DBUILD_TESTS:BOOL" = false,
    },
    # preConfigurePhase = [
    #     m%"sed -i 's@ SHARED @ @g' ${SRC}/core/CMakeLists.txt"%
    # ]
  }
}
& {
  lib,

  googletest | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/googletest/releases/download/v1.16.0/googletest-1.16.0.tar.gz",
      sha256sum = "78c676fc63881529bf97bf9d45948d905a66833fbfa5318ea2cd7478cb98f399"
    }
  }
}
& {
  lib,

  nlohmannJson,
  nlohmannJsonCmake | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/nlohmann/json/archive/11a835df85677002a8aadc5b4e945684c5b7f68b.zip",
      sha256sum = "8320fab51a221259d50f47911c05b90eb07d8e13b2e9388fd56372a7be30e702"
    }
  }
}
