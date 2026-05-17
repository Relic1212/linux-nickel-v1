{
  drvs,
  lib,
  libndp | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://libndp.org/files/libndp-1.9.tar.gz",
      sha256sum = "a8ab214e01dc3a9b615276905395637f391298c84d77651f0cbf0b1082dd2dd4",
    },
    buildEnv = {
      EXTRA_CFLAGS = ["-Wno-incompatible-pointer-types", ],
    },
  }
}
