{
  lib,
  fscryptUnlockHome | lib.Package = {
    name = "fscrypt-unlock-home",
    extraFiles = [
      {
        file = "crypto-login.sh",
        sha256sum = "6af7a1bd52c71eb0834d620039130071dfb0c385745763a8fa6d39416d1d27cf",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
