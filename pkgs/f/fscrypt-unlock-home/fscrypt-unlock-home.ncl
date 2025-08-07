{
  lib,
  fscryptUnlockHome | lib.Package = {
    name = "fscrypt-unlock-home",
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
