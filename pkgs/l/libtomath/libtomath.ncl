{
  lib,
  drvs,
  libtommath | lib.MakePackage = {
    # generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libtom/libtommath/archive/refs/tags/v1.3.0.tar.gz",
      sha256sum = "6d099e93ff00fa9b18346f4bcd97dcc48c3e91286f7e16c4ac5515a7171c3149"
    },
    extraMakeArgs =
      [
        "-f makefile.unix",
      ]
      @ [
        m%"CC="${CC}""%,
        m%"CFLAGS="${CFLAGS}""%,
      ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr"
      ]
  }
}
