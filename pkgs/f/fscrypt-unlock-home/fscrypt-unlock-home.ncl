{
  lib,
  fscryptUnlockHome | lib.Package
    = {
      name = "fscrypt-unlock-home",
      extraFiles = [
        {
          file = "crypto-login.sh",
          sha256sum = "e8972e119970d8023c9641333861c9f5536456d60001a30f506f9a4447ff566b",
        }
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
      ]
    }
}
