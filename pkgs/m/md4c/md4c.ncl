{
  lib,
  drvs,
  md4c | lib.CmakePackage = {
    singleSource = {
      uri = "https://github.com/mity/md4c/archive/refs/tags/release-0.5.3.tar.gz",
      sha256sum = "353c346f376b87c954a13f3415ede2d51264cc61dc5abcd38ff1d2aa0d059b9e",
    },
    generator = "Ninja",
  }
}
