{
  lib,
  drvs,
  libdwarf | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/davea42/libdwarf-code/archive/refs/tags/v2.3.1.tar.gz",
      sha256sum = "0caec41d0a6294de5548273d7d47d7944a0d25b003b64b119bf2580c2ee49ad9",
    }
  }
}
