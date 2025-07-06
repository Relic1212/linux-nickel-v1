{
  lib,
  attr,

  acl | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.savannah.nongnu.org/releases/acl/acl-2.3.2.tar.xz",
      sha256sum = "97203a72cae99ab89a067fe2210c1cbf052bc492b479eca7d226d9830883b0bd"
    },
    biDrvs =
      lib.biMap [
        attr,
      ]
  }
}
