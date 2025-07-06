{
  lib,

  pandoc | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/jgm/pandoc/archive/refs/tags/3.5.tar.gz",
      sha256sum = "1d378e5721eb26ebcdc31232dcd26d041eb3237e85ac3650ce809e9fa0fcacb8"
    }
  }
}
