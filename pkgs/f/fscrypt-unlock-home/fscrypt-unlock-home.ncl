{
  lib,
  fscryptUnlockHome | lib.Package = {
    name = "fscrypt-unlock-home",
    extraFiles = [
      {
        file = "crypto-login.sh",
        sha256sum = "db9ec92aa753de9ff2692e7658ddd90aecb7db970ab7121775a039dd05731428",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
