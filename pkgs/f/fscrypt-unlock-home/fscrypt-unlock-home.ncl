{
  lib,
  fscryptUnlockHome | lib.Package
    = {
      name = "fscrypt-unlock-home",
      extraFiles = [
        {
          file = "crypto-login.sh",
          sha256sum = "82279017c6e20848d670c1d81c6837c6cacdc7ed05eb2f3a368193ca91ae1c15",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
      ]
    }
}
