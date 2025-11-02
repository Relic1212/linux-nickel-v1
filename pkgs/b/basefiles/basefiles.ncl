{
  lib,
  basefiles | lib.Package = {
    extraFiles = [
      # {
      #   file = "basefiles",
      #   sha256sum = "d90eff754c8e52c0ebb9c4b99c7e04e9d542e0c592ec49ad0d5d60427495679b"
      # },
      {
        sha256sum = "d18b26020a391c1299ef04354971cdda5d42cef6439749b91e028436d3f77e70",
        file = "shells"
      },
      {
        sha256sum = "a81ff4d3c1938fbfeb431a1a646d566f2612bb2b20ea97414c0ceca9e7146bf8",
        file = "hosts"
      },
      {
        sha256sum = "74e2371427f92276ea9c2160e009b66fa6422963f9b49d80c056807ba8006feb",
        file = "os-release"
      },
      {
        sha256sum = "c6870adb8ca864276d17f9df4d820dc64cdc92c867cb3ea5f1420e22fb3b1af9",
        file = "passwd",
      },
      {
        sha256sum = "caf90169eefa5f807d577486b9f795ab86ae2983c5c20806cff959117e90af18",
        file = "hostname",
      },
      {
        sha256sum = "20c89d8a140dc17acd3b966a963b5baeb82f179db7075f03c73fd349110f9a03",
        file = "fscrypt.conf"
      },
      {
        sha256sum = "c94fe87bcc591acc8afecf4c7d179f52935f136c0716677d1ccdb0b28cd1df67",
        file = "group"
      },
      {
        sha256sum = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        file = "shadow",
      },
      {
        sha256sum = "bad48659936660116b1a34d4a43346b2498a01a30cc5d9051658384f327018e8",
        file = "main.conf",
      },
      {
        sha256sum = "e882fd36c50789bc7793343968f77afba340de3532a3bfa3b6ca5da62565fbfd",
        file = "fstab",
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
      "install -m0755 /tmp/workdir/files/passwd ${DEST}/etc",
      "install -m0755 /tmp/workdir/files/group ${DEST}/etc",
      "install -m0600 /tmp/workdir/files/shadow ${DEST}/etc",
      "install -m0755 /tmp/workdir/files/fstab ${DEST}/etc",
      "install -m0755 /tmp/workdir/files/hostname ${DEST}/etc",
      "install -m0755 /tmp/workdir/files/hosts ${DEST}/etc",
      "install -d  ${DEST}/etc/iwd",
      "install -m0755 /tmp/workdir/files/main.conf ${DEST}/etc/iwd/main.conf",
      "install -m0755 /tmp/workdir/files/fscrypt.conf ${DEST}/etc/",
      "install -m0755 /tmp/workdir/files/os-release ${DEST}/etc/",
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
      "install -d -m0755 ${DEST}/boot",
      "install -d -m0755 ${DEST}/efi",
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
