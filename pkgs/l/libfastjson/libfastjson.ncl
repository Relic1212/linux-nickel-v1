{
  lib,
  libfastjson | lib.AutomakePackage
    = {
      singleSource = {
        uri = "https://github.com/rsyslog/libfastjson/archive/refs/tags/v1.2304.0.tar.gz",
        sha256sum = "6c18848c75b179108429fc2818273551c68ffe6ddd5e414c20c071c844befbc1",
      }
    }
}
