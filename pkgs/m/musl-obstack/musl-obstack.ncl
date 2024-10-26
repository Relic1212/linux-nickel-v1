{
  lib,
  muslObstack | lib.AutomakePackage
    = {
      name = "musl-obstack",
      singleSource = {
        uri = "https://github.com/void-linux/musl-obstack/archive/refs/tags/v1.2.3.tar.gz",
        sha256sum = "9ffb3479b15df0170eba4480e51723c3961dbe0b461ec289744622db03a69395",
      }
    }
}
