{
  lib,
  caCertificates | lib.Package = {
    singleSource = {
      uri = "https://curl.se/ca/cacert-2025-02-25.pem",
      sha256sum = "50a6277ec69113f00c5fd45f09e8b97a4b3e32daa35d3a95ab30137a55386cef",
    },
    installPhase = [
      "install -d -m0755 ${DEST}/etc/ssl",
      "install -m 0755 ${SRC}/cacert*.pem ${DEST}/etc/ssl/cert.pem",
    ]
  }
}
& {
  lib,

  mozillaCerts | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://archive.mozilla.org/pub/security/nss/releases/NSS_3_96_RTM/src/nss-3.96.tar.gz",
      sha256sum = "b38f276151b0a0be0b4f3951d6213ace289f00acd52bef05bc0fe1efc99039dd"
    }
  }
}
