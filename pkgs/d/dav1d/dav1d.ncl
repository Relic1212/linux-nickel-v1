{
  lib,
  drvs,
  dav1d | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/videolan/dav1d/archive/refs/tags/1.5.4.tar.gz",
      sha256sum = "a1d5b63d2d38ec9bd03acf643caa51fa22edd1e89c5a109c4807717216bbec07",
    },

    extraMesonArgs = [
      "-Denable_tests=false",
    ],

    biDrvs = [
      drvs.nasm,
    ],
  }
}
