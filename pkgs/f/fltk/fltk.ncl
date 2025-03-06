{
  lib,
  drvs,
  fltk | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/fltk/fltk/archive/refs/tags/release-1.4.0-1.tar.gz",
      sha256sum = "9a1123fe59a3879237c3ee3a56f3b6e10fdaad037b0e6a472df7ca4aaffd6654"
    }
  }
}
