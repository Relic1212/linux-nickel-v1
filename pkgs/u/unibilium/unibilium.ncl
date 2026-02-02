{
  lib,
  drvs,
  unibilium | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/neovim/unibilium/archive/refs/tags/v2.1.2.tar.gz",
      sha256sum = "370ecb07fbbc20d91d1b350c55f1c806b06bf86797e164081ccc977fc9b3af7a",
    }
  }
}
