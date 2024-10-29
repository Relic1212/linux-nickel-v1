{
  lib,
  basefiles | lib.Package
    = {
      extraFiles = [
        {
          file = "basefiles",
          sha256sum = "1b78b796700e14c3663fb0c6e1d381fc965b07e5cb152d9e8a88c7d23c14f327"
        }
      ],

      installPhase = [
        "install -d -m0755 ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/shells ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/passwd ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/group ${DEST}/etc",
        "install -m0600 /tmp/workdir/files/basefiles/shadow ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/fstab ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/hostname ${DEST}/etc",
        "install -m0755 /tmp/workdir/files/basefiles/hosts ${DEST}/etc",
        "install -d  ${DEST}/etc/iwd",
        "install -m0755 /tmp/workdir/files/basefiles/iwd/main.conf ${DEST}/etc/iwd/main.conf",
        "install -m0755 /tmp/workdir/files/basefiles/fscrypt.conf ${DEST}/etc/",
        "install -m0755 /tmp/workdir/files/basefiles/os-release ${DEST}/etc/",
        "install -d -m0755 ${DEST}/proc",
        "install -d -m0755 ${DEST}/sys",
        "install -d -m0755 ${DEST}/mnt",
        "install -d -m0755 ${DEST}/home",
        "install -d -m0755 ${DEST}/nix",
        "install -d -m0755 ${DEST}/dev/pts",
        "install -d -m0755 ${DEST}/dev/shm",
        "install -d -m0755 ${DEST}/var/log",
        "install -d -m0755 ${DEST}/run",
        "install -d -m0755 ${DEST}/tmp",
        "install -d -m0755 ${DEST}/root",
        "cd ${DEST}/var",
        "ln -s /run run",
        "ln -s /tmp tmp",
      ]
    },
  basefilesAarch64 = basefiles & { buildEnv.TARGET = "aarch64-unknown-linux-musl" },
}
