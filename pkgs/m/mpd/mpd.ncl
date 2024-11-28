{
  lib,
  drvs,
  mpd | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/jcorporation/myMPD/archive/refs/tags/v18.2.0.tar.gz",
        sha256sum = "29f912ed806d7fa60a067a7f7a02a1202d2f97ae64d7e4eca736259ed13fee56"
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
