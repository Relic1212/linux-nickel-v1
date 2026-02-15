{
  lib,
  drvs,
  googlefontsNotoEmoji | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/googlefonts/noto-emoji/archive/refs/tags/v2.047.tar.gz",
      sha256sum = "2cfaf5a427eb26334cdb30d98e4a0c005b660504a339249dc54373e566f09b50"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.zopfli,
    ]
  }
}
& {
  lib,
  drvs,
  zopfli | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/google/zopfli/archive/ccf9f0588d4a4509cb1040310ec122243e670ee6.zip",
      sha256sum = "d1bc572f62aebe5d7bb6d5cac6ec5be2562de6d75f9116887eeeb52c3fcf3cdf"
    },
    cmakeExtraArgsRecord = {
      "-DCMAKE_POLICY_VERSION_MINIMUM" = "3.5"
    },
  }
}
& {
  lib,
  drvs,
  nototools | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://github.com/notofonts/nototools/archive/refs/tags/v0.2.20.tar.gz",
      sha256sum = "c399008b7fe1f13d46f6e21fcac9abfaaae70f48ce4b9e20f65443650fb4c0d8"
    }
  }
}
