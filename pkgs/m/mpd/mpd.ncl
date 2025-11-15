{
  lib,
  drvs,
  mpd | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/jcorporation/myMPD/archive/refs/tags/v22.1.2.tar.gz",
      sha256sum = "c992c1e9e02fdff42d7c3ede8e99baa9727d510716005e6fd4958de6eab17da8"
    },
    biDrvs = [
      drvs.perl,
      drvs.jq,
      drvs.lua,
      drvs.pcre2,
      drvs.openssl,
      drvs.zlibNg,
      drvs.ffmpeg,
    ],
    cmakeArgsRecord = {
      "-DMYMPD_DOC" = false,
    }
  }
}
