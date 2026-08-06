{
  lib,
  drvs,
  caCertificates | lib.Package = {
    singleSource = {
      uri = "https://curl.se/ca/cacert-2025-02-25.pem",
      sha256sum = "50a6277ec69113f00c5fd45f09e8b97a4b3e32daa35d3a95ab30137a55386cef",
    },
    installPhase = [
      "install -d -m0755 ${DEST}/etc/ssl",
      "install -m 0755 ${SRC}/cacert*.pem ${DEST}/etc/ssl/cert.pem",
    ]
  },

  caCertificatesDebian | lib.MakePackage = {
    singleSource = {
      uri = "https://salsa.debian.org/debian/ca-certificates/-/archive/debian/20211016/ca-certificates-debian-20211016.tar.bz2",
      sha256sum = "95c514375faa4b4c22566fd2ad9cd988cf57644ec911707b87c5bc8e8b39c6e6",
    },
    biDrvs = [
      drvs.pythonFull,
    ],
  },

  caCertificatesAlpine | lib.MakePackage = {
    singleSource = {
      uri = "https://gitlab.alpinelinux.org/alpine/ca-certificates/-/archive/20260611/ca-certificates-20260611.tar.bz2",
      sha256sum = "32ca73f2e81e2b88dc614f12e1ee04a82b1ec5a8e29d9f359ddf8905a0afcbb0",
    },
    preConfigurePhase = [
      "sed -i 's|sbin|bin|g' Makefile",
    ],
    biDrvs = [
      drvs.perl,
    ],
    pDrvs = [
      drvs.openssl,
    ],
  },
}
& {
  lib,
  drvs,
  mozillaCerts | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://archive.mozilla.org/pub/security/nss/releases/NSS_3_96_RTM/src/nss-3.96.tar.gz",
      sha256sum = "b38f276151b0a0be0b4f3951d6213ace289f00acd52bef05bc0fe1efc99039dd"
    }
  }
}
