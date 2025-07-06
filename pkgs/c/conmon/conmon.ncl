{
  lib,
  glib,
  pcre2,
  libffi,
  zlibNg,
  libseccomp,
  gperf,
  linuxHeaders,

  conmon | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/containers/conmon/archive/refs/tags/v2.1.12.tar.gz",
      sha256sum = "842f0b5614281f7e35eec2a4e35f9f7b9834819aa58ecdad8d0ff6a84f6796a6"
    },
    biDrvs =
      lib.biMap [
        glib,
        pcre2,
        libffi,
        zlibNg,
        libseccomp,
        gperf,
        linuxHeaders,
      ]
  }
}
