{
  lib,
  basefiles | lib.Package = {
    extraFiles = [
      {
        file = "basefiles",
        sha256sum = "cda0cb973164e39ec4b82ee716cd7ab1f003a78c67535f5e847dbd6c4c4595dc"
      }
    ],

    installPhase = [
      "install -d -m0755 ${DEST}/etc",
      # "install -m0755 /tmp/workdir/files/basefiles/shells ${DEST}/etc",
      m%"
        echo "/bin/sh
        /usr/bin/zsh
        /usr/bin/fish" > ${DEST}/etc/shells"%,
      # m%"echo "root:1000000:65536\nuser:100000:165536\n" > ${DEST}/etc/subgid"%,
      # m%"echo "root:1000000:65536\nuser:100000:165536\n" > ${DEST}/etc/subuid"%,
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
      "install -d -m0755 ${DEST}/usr/share/secureboot",
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
& {
  lib,
  mountOthers | lib.Package = {
    installPhase =
      let
      #d = "/usr/libexec"
      d = "/etc/dinit.d/scripts/" in [
        "install -d -m0755 ${DEST}%{d}",
        m%"
      echo "#!/bin/sh
      if [ -e /dev/disk/by-partlabel/data_partition ]; then
	      mkdir -p /run/data
	      mount -o noatime /dev/disk/by-partlabel/data_partition /run/data
      fi
      " > ${DEST}%{d}/mount-other.sh
      "%,
        "chmod +x ${DEST}%{d}/mount-other.sh",
      ]
  }
}
