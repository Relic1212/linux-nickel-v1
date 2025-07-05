{
  lib,
  drvs,
  dinitUtils | lib.Package = {
    extraFiles = [
      {
        file = "early-filesystems.c",
        sha256sum = "9f06539d1e28a91951e95aefee5de1c27c33eb450208ed389bc40db652c65b0a",
      }
    ],
    buildPhase = [
      "${CC} ${CFLAGS} /tmp/workdir/files/early-filesystems.c -o /tmp/workdir/build/mount-early",
      # "clang -static /tmp/workdir/files/early-filesystems.c -o /tmp/workdir/build/mount-early",
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/libexec",
      "install -m0755 /tmp/workdir/build/mount-early ${DEST}/usr/libexec",
    ],
    enableCcache = false,
    biDrvs =
      [
        drvs.llvm,
        drvs.musl,
      ]
  }
}
