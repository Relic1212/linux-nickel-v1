{
  lib,
  fscryptUnlockHome | lib.Package = {
    extraFiles = [
      {
        file = "crypto-login.sh",
        sha256sum = "413cc7d7257f285d469088d3bb13662e886fb253ae6d14002bd9ee151c9b8597",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
& {
  lib,
  fscryptUnlockHomeElogind | lib.Package = {
    extraFiles = [
      {
        file = "crypto-login-elogind.sh",
        sha256sum = "96e3428dfee5ff5fb3b853a52148f63cc9063eb85f181b5324234e0631fb525d",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login-elogind.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
