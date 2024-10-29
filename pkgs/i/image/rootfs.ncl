{
  lib,
  pkgs,
  _rootfs | lib.Package
    = {
      buildInChroot = false,
      utilsProviders = [],
      installPhase = [
        "cp -r /tmp/workdir/sysroot /tmp/workdir/out/destdir/rootfs",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/include",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/cmake",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.a",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.la",
        "find /tmp/workdir/out/destdir/rootfs/usr/bin -type f |xargs strip > /dev/null ||echo true ",
      ],
    },

  _rootfs2 | lib.Package
    = {
      buildPhase =
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
          "useradd -M -s /bin/sh -G wheel,seat,video,audio  user",
          # useradd -u 461 -g 11 -d /var/run/sndiod sndiod
          # "ln -s /usr/lib /lib",
          # For testing only

          # For shadow:
          # "echo p |passwd --stdin",
          # "echo p |passwd user --stdin",
          # For bb:
          "chpasswd root:p",
          "chpasswd user:user",
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

        [
          "cp -r /rootfs /tmp/workdir/out/destdir/rootfs",
          m%"
  chroot /tmp/workdir/out/destdir/rootfs <<"EOT"
  %{std.string.join "\n" chrootPhase}
  EOT
  "%,
          "genimage -r image -p a -d /tmp/workdir/out/destdir/rootfs -s /usr/lib/systemd/boot/efi/linuxx64.efi.stub -o /tmp/workdir/out/image"
        ],
    },
}
