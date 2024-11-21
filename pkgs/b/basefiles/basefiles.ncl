{
  lib,
  basefiles | lib.Package
    = {
      extraFiles = [
        {
          file = "basefiles",
          sha256sum = "d90eff754c8e52c0ebb9c4b99c7e04e9d542e0c592ec49ad0d5d60427495679b"
        }
      ],

      installPhase = [
        "install -d -m0755 ${DEST}/etc",
        # "install -m0755 /tmp/workdir/files/basefiles/shells ${DEST}/etc",
        m%"echo \"/bin/sh\n/usr/bin/zsh\n/usr/bin/fish\n\" > ${DEST}/etc/shells"%,

        m%"echo "root:1000000:65536\nuser:100000:165536" > ${DEST}/etc/subgid"%,
        m%"echo "root:1000000:65536\nuser:100000:165536" > ${DEST}/etc/subuid"%,


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
