{
  lib,
  drvs,
  howardHinnantDate | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/HowardHinnant/date/archive/refs/tags/v3.0.4.tar.gz",
      sha256sum = "56e05531ee8994124eeb498d0e6a5e1c3b9d4fccbecdf555fe266631368fb55f",
    },
    cmakeExtraArgsRecord = {

      "-DBUILD_TZ_LIB" = true,
    },
    pDrvs = [
      drvs.curl,
    ]
  }
}
