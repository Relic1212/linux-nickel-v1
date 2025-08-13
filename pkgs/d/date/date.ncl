{
  lib,
  drvs,
  date | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/HowardHinnant/date/archive/v3.0.1.tar.gz",
      sha256sum = "7a390f200f0ccd207e8cff6757e04817c1a0aec3e327b006b7eb451c57ee3538"
    }
  }
}
