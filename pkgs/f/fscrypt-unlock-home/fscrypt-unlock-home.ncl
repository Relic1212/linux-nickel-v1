{
  lib,
  fscryptUnlockHome | lib.Package
    = {
      name = "fscrypt-unlock-home",
      extraFiles = [
        {
          file = "crypto-login.sh",
          sha256sum = "642dd4e9a0594a3ffe3d01b5fd9bc4e44c03dc257442a558b19ddad99ca58d9e",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
      ]
    }
}
