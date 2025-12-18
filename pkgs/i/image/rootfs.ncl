{
  lib,
  _rootfs | lib.Package = {
    buildInChroot = false,
    utilsProviders = [],
    installPhase =
      [
        "echo 'copying the rootfs'",

        # "cp -a /tmp/workdir/sysroot /tmp/workdir/out/destdir/rootfs",
        "mkdir /tmp/workdir/out/destdir/rootfs",
        m%"
        for d in $(ls /tmp/workdir/sysroot);do
          echo "copying ${d}"
          cp -a /tmp/workdir/sysroot/${d} /tmp/workdir/out/destdir/rootfs
        done
        "%,
        # m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs /tmp/workdir/sysroot /tmp/workdir/out/destdir/rootfs"%,
        "echo 'removing useless stuff'",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/include",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/cmake",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/pkgconfig",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/pkgconfig",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.a",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.la",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.prl",
        # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/systemd",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/ossl-modules",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/kernel",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/gdb",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/emacs",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/common-lisp",
      ]
      @ (
        if (true) then
          [
            # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/bin",
            # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/plugins",
            # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/libexec",
            "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/objects-Release",
            "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -name '*.a'); do rm -rf $d; done",
            "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -name '*.prl'); do rm -rf $d; done",
            "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -empty); do rm -rf $d; done",
          ]
        else
          []
      )
      @ (
        if (true) then
          [

            # bash files 
            "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/bash-completion",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/yad-settings",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/try_swap_workspace",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/scratchpad",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rsync-ssl",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rofi-theme-selector",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rofi-sensible-terminal",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/hdrop",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/grimblast",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/tzselect",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/pa-info",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/alsaconf",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/alsa-info.sh",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/e2scrub_all",
            "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/e2scrub",
          ]
        else
          []
      )
      @ [

        # perl
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/c_rehash",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/git-cvsserver",

        # to mount a tmpfs here for debugging
        "mkdir -p /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/qml/"

        # "echo 'stripping binaries'",
        # "find /tmp/workdir/out/destdir/rootfs/usr/bin -type f |xargs strip > /dev/null ||echo true ",
      ],
  },

  _rootfs2 | lib.Package = {
    buildPhase =
      let shell = "/usr/bin/fish" in
      let chrootPhase = [
        # "mkdir -p -m0755 /proc",
        # "mkdir -p -m0755 /sys",
        # "mkdir -p -m0755 /mnt",
        # "mkdir -p -m0755 /home",
        # "mkdir -p -m0755 /nix",
        # "mkdir -p -m0755 /dev/pts",
        # "mkdir -p -m0755 /dev/shm",
        # "mkdir -p -m0755 /var/log",
        # "mkdir -p -m0755 /run",
        # "mkdir -p -m0755 /tmp",
        # "ln -s /run /var/run",
        "mkdir -p -m 0755 /run/dropbear",
        "ln -s /run/dropbear /etc/dropbear",
        "mkdir -p -m 0755 /var/lib/power-profiles-daemon",
        # FIXME
        # "mkdir -p -m0755 /root",
        # "echo 'pipewire:x:509:' >> /etc/group",
        "groupadd -r -g 509 pipewire",
        "groupadd -r -g 272 plugdev",
        "useradd -M -s %{shell} -G wheel,seat,video,audio,input,pipewire,plugdev user",
        "useradd -M -s %{shell} -G wheel,seat,video,audio,input,pipewire,plugdev user1",
        "groupadd -r -g 102 polkitd",
        "useradd -r -u 102 -g 102 -G polkitd -M -s /usr/bin/nologin -d /var/empty polkitd",
        "chown --verbose -R root:polkitd /usr/share/polkit-1/rules.d",
        "chmod 0750 /usr/share/polkit-1/rules.d",
        "if [ -e /usr/bin/greetd ]; then useradd -M -s /usr/bin/nologin -d /var/lib/greeter -G video,input greeter ;mkdir -p /var/lib/greeter; chown -R greeter:greeter /var/lib/greeter; sed -i 's|vt = 1|vt = 3|g' /etc/greetd/config.toml; fi",
        # "if [ -e /usr/bin/greetd ]; sed -i 's|bin\/sh||g' /etc/greetd/config.toml; fi",
        "if [ -e /usr/bin/cosmic-greeter ]; then useradd -M -s /usr/bin/nologin -d /var/lib/cosmic-greeter -G video cosmic-greeter ;mkdir -p /var/lib/cosmic-greeter; chmod 750 /var/lib/cosmic-greeter; chown -R cosmic-greeter: /var/lib/cosmic-greeter; fi",
        "if [ -e /usr/libexec/rtkit-daemon ]; then groupadd -r -g 133 rtkit; useradd -r -u 133 -g 133 -M -s /usr/bin/nologin -d / rtkit; fi",

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
        "(cd /etc && ln -s  ../proc/mounts mtab)",

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
        "if [ -f /usr/bin/glib-compile-schemas  ]; then /usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas; fi"

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
        "mkdir /tmp/workdir/out/destdir/rootfs",
        m%"rsync -a --no-compress --no-o --no-g --perms --acls --xattrs --exclude=/usr/include --exclude=/usr/lib/*.a /rootfs/ /tmp/workdir/out/destdir/rootfs/"%,

        # "cp -r /rootfs /tmp/workdir/out/destdir/rootfs",
        "echo 'removing useless stuff'",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/include",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/cmake",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/pkgconfig",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/pkgconfig",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.a",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.la",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/*.prl",
        # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/systemd",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/ossl-modules",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/kernel",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/bin",
        # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/plugins",
        # "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/libexec",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/lib/objects-Release",
        "rm -rf /tmp/workdir/out/destdir/rootfs/usr/share/gdb",
        "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -name '*.a'); do rm -rf $d; done",
        "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -name '*.prl'); do rm -rf $d; done",
        "for d in $(find /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/ -empty); do rm -rf $d; done",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/share/bash-completion",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/share/emacs",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/share/common-lisp",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/share/hypr/wall0.png",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/share/hypr/wall1.png",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/python3.12/config-3.12-x86_64-linux-gnu/*.a",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/python3.12/test/__pycache__/*",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/python3.12/__pycache__/*",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-file.so",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/gtk-query-im*",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/bin/gtk-builder-tool",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/gnome-keyring/devel",
        "rm -rf  tmp/workdir/out/destdir/rootfs/usr/lib/bash",

        # bash files 
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/yad-settings",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/try_swap_workspace",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/scratchpad",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rsync-ssl",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rofi-theme-selector",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/rofi-sensible-terminal",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/hdrop",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/grimblast",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/tzselect",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/pa-info",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/alsaconf",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/alsa-info.sh",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/e2scrub_all",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/e2scrub",

        # perl
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/c_rehash",
        "rm -f /tmp/workdir/out/destdir/rootfs/usr/bin/git-cvsserver",

        # to mount a tmpfs here for debugging
        "mkdir -p /tmp/workdir/out/destdir/rootfs/usr/lib/qt6/qml/",

        # "echo GTK_IM_MODULE=simple >> /tmp/workdir/out/destdir/rootfs/etc/environment",

        # "echo 'stripping binaries'",
        # "find /tmp/workdir/out/destdir/rootfs/usr/bin -type f |xargs strip > /dev/null ||echo true ",
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
          if [ -e /tmp/workdir/out/destdir/rootfs/usr/bin/fusermount3 ]; then
            chmod u+s /tmp/workdir/out/destdir/rootfs/usr/bin/fusermount3
          fi
          "%,
        m%"
          if [ -e /tmp/workdir/out/destdir/rootfs/usr/lib/polkit-1/polkit-agent-helper-1 ]; then
            chmod u+s /tmp/workdir/out/destdir/rootfs/usr/lib/polkit-1/polkit-agent-helper-1
          fi
          "%,
        m%"
          if [ -e /tmp/workdir/out/destdir/rootfs/usr/libexec/dbus-daemon-launch-helper ]; then
            chmod u+s /tmp/workdir/out/destdir/rootfs/usr/libexec/dbus-daemon-launch-helper
          fi
          "%,
        # "touch /tmp/workdir/out/destdir/rootfs/etc/mtab",

        # https://community.frame.work/t/system-gets-really-slow/61854/2
        m%"export EXTRA_CMDLINE="console=tty1 sysctl.kernel.sysrq=1 raid=noautodetect amdgpu.dcdebugmask=0x10 ro rootwait lsm=lockdown,capability firmware_class.path=/usr/lib/firmware""%,
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
