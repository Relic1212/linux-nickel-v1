{
  lib,
  drvs,
  glibmm | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz",
      sha256sum = "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libsigcpp2,
    ]
  }
}
& {
  lib,
  drvs,
  glibmm_2_82 | lib.MesonPackage = {
    singleSource = {
      #uri = "https://download.gnome.org/sources/glibmm/2.68/glibmm-2.68.2.tar.xz",
      #sha256sum = "91e0a8618f7b82db4aaf2648932ea2bcfe626ad030068c18fa2d106fd838d8ad"
      #uri = "https://download.gnome.org/sources/glibmm/2.83/glibmm-2.83.1.tar.xz",
      #sha256sum = "68350a823c33da8acfb1263715bb002a36c68346bd44c19ac4c3f0bd190fd2b1",
      uri = "https://download.gnome.org/sources/glibmm/2.82/glibmm-2.82.0.tar.xz",
      sha256sum = "38684cff317273615c67b8fa9806f16299d51e5506d9b909bae15b589fa99cb6"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libsigcpp,
    ],
    extraMesonArgs = [
      "-Dbuild-examples=false",
    ]
  }
}
