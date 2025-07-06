{
  lib,

  linuxHeaders,

  fuse | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/libfuse/libfuse/releases/download/fuse-3.16.2/fuse-3.16.2.tar.gz",
      sha256sum = "f797055d9296b275e981f5f62d4e32e089614fc253d1ef2985851025b8a0ce87",
    },

    biDrvs =
      lib.biMap [
        linuxHeaders,
      ],
    extraMesonArgs = [
      "-Duseroot=false",
    ]
  }
}
