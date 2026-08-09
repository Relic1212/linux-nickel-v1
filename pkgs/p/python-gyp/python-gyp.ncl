{
  lib,
  drvs,
  pythonGyp | lib.SetuptoolPackage = {
    singleSource = {
      uri = "https://chromium.googlesource.com/external/gyp.git",
      sha256sum = "1615ec326858f8c2bd8f30b3a86ea71830409ce4",
      fetchMethod = "git",
    },
  }
}
