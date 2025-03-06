{
  lib,
  pkgs,
  _rootfs | lib.Package = {
    buildInChroot = false,
    utilsProviders = [],
    installPhase = [
      "echo 'copying the rootfs'",

      #"cp -r /tmp/workdir/sysroot /tmp/workdir/out/destdir/rootfs",
      "mkdir /tmp/workdir/out/destdir/rootfs",
      m%"
        for d in $(ls /tmp/workdir/sysroot);do
          echo "copying ${d}"
          cp -a /tmp/workdir/sysroot/${d} /tmp/workdir/out/destdir/rootfs
        done
        "%,
      "echo 'removing useless stuff'",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/include",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/cmake",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/pkgconfig",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/pkgconfig",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.a",
      "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.la",

      # "echo 'stripping binaries'",
      # "find /tmp/workdir/out/destdir/rootfs/usr/bin -type f |xargs strip > /dev/null ||echo true ",
    ],
  },

  _rootfs2 | lib.Package = {
    buildPhase =
      let shell = "/usr/bin/fish" in
      let chrootPhase = [
        # "install -d -m0755 /proc",
        # "install -d -m0755 /sys",
        # "install -d -m0755 /mnt",
        # "install -d -m0755 /home",
        # "install -d -m0755 /nix",
        # "install -d -m0755 /dev/pts",
        # "install -d -m0755 /dev/shm",
        # "install -d -m0755 /var/log",
        # "install -d -m0755 /run",
        # "install -d -m0755 /tmp",
        # "ln -s /run /var/run",
        "install -d -m 0755 /run/dropbear",
        "ln -s /run/dropbear /etc/dropbear",
        # FIXME
        # "install -d -m0755 /root",
        "useradd -M -s %{shell} -G wheel,seat,video,audio,input user",
        "useradd -M -s %{shell} -G wheel,seat,video,audio,input user1",

        # useradd -u 461 -g 11 -d /var/run/sndiod sndiod
        # "ln -s /usr/lib /lib",
        # For testing only

        # For shadow:
        # "echo p |passwd --stdin",
        # "echo p |passwd user --stdin",
        # For bb:
        m%"
          chpasswd <<EOF
          root:p
          EOF
          "%,
        # m%"
        # chpasswd <<EOF
        # user:p
        # EOF
        # "%,
        m%"
          kver=$(ls /usr/lib/modules)
          depmod $kver
          "%,
        "makewhatis /usr/share/man",
        "command -v dbus-uuidgen && dbus-uuidgen > /etc/machine-id",
        m%"
          for d in $(find / -type d); do
            chmod 0755 "${d}"
          done
          "%,
        m%"echo "root:1000000:65536\nuser:100000:165536\n" > /etc/subgid"%,
        m%"echo "root:1000000:65536\nuser:100000:165536\n" > /etc/subuid"%,
        "setcap cap_setgid=ep /usr/bin/newgidmap",
        "setcap cap_setuid=ep /usr/bin/newuidmap",

        # https://github.com/flatpak/flatpak/issues/5488
        "mkdir -p /var/lib/flatpak",
        "cd /var/lib/flatpak",
        "mkdir -p repo/objects repo/tmp",
        m%"
          echo "
          [core]
          repo_version=1
          mode=bare-user-only
          min-free-space-size=500MB
          " > repo/config
          "%,

        # m%"
        # mv /lib/firmware /lib/firmware.unneeded
        # mkdir /lib/firmware
        # find /lib/modules/ -type f -print | xargs modinfo {}|grep "firmware:"| cut -d " " -f8 > /lib/firmware.needed

        # cd /lib/firmware.unneeded
        # for needed in $(cat  /lib/firmware.needed); do
        #     if [ -f ${needed} ]; then
        #       d=$(dirname ${needed})
        #       mkdir -p /lib/firmware/${d}
        #       mv ${needed} /lib/firmware/${needed}
        #     fi
        # done
        # "%
      ]
      in

      let
      # rootauuid="d17c04a8-398e-4809-92ee-c7f17f4d6fdb"
      rootauuid = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa" in

      [
        "echo 'copying rootfs to chroot dir'",
        "cp -r /rootfs /tmp/workdir/out/destdir/rootfs",
        m%"
          chroot /tmp/workdir/out/destdir/rootfs <<"EOT"
          %{std.string.join "\n" chrootPhase}
          EOT
          "%,
        m%"
          if [ -e /tmp/workdir/out/destdir/rootfs/usr/bin/doas ]; then
            chmod u+s /tmp/workdir/out/destdir/rootfs/usr/bin/doas
          fi
          "%,
        m%"
          genimage \
          -r image \
          -p "%{rootauuid}" \
          -d /tmp/workdir/out/destdir/rootfs \
          -s /usr/lib/systemd/boot/efi/linuxx64.efi.stub \
          -o /tmp/workdir/out/image
          "%
      ],
  },
}
