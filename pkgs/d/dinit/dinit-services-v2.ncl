let Service = {
  type | String,

  command | String | optional,

  "inittab-id" | optional,
  "inittab-ine" | optional,
  logfile | String | optional,
  options | optional,
  "pid-file" | String | optional,
  "ready-notification" | optional,
  restart | Bool | optional,
  "smooth-recovery" | Bool | optional,
  "start-timeout" | String | optional,
  "stop-command" | String | optional,
  termsignal | optional,
  "waits-for" | Array String | default = [],
  "depends-ms" | Array String | default = [],
  "depends-on" | Array String | default = [],
}
in
let serviceToString = (fun service =>
  let _arr_arr = (
    std.record.map
      (fun k v =>
        (
          if (std.is_string v) then
            ["%{k} = %{v}"]
          else if (std.is_array v) then
            (std.array.map (fun vi => "%{k} = %{vi}") v)
          else if (std.is_bool v) then
            ["%{k} = %{std.to_string v}"]
          else
            []
        )
      )
      service
  )
  in
  let _arr = std.array.flatten (std.record.values _arr_arr)
  in
  std.string.join "\n" _arr
)
in
let _services = {
  boot | Service
    = {
      type = "internal",
      "depends-ms" = ["tty1", "tty2", "seatd"],

      "waits-for" = ["dbusd", "dhcpcd", "dropbear"],
    }
}
in

let services = {
  boot2 = serviceToString _services.boot,
  boot = m%"
            type = internal
            depends-ms = tty1
            depends-ms = tty2
            waits-for=dbusd
            depends-ms=seatd
            waits-for=dhcpcd
            waits-for=dropbear
            "%,

  cfg80211 = m%"
            type = scripted
            command = modprobe cfg80211
            restart = false
            depends-on=early-filesystems
            "%,
  dbusd = m%"
            type = process
            command = /usr/bin/dbus-daemon --system --nofork --nopidfile --print-address=4
            depends-on = rcboot
            logfile = /var/log/dbus-daemon.log
            ready-notification = pipefd:4
            smooth-recovery = yes
            "%,
  dhcpcd = m%"
            type = process
            command = /usr/bin/dhcpcd -B -M --logfile /var/log/dhcpcd-service.log
            logfile = /var/log/dhcpcd.log
            restart = false
            depends-on = varrw
            depends-on = netdev-eth0
            "%,
  dropbear = m%"
            type = process
            command = /usr/bin/dropbear -E -F -P /run/dropbear.pid -R
            logfile = /var/log/dropbear.log
            depends-on = dhcpcd
            depends-on = netdev-eth0
            depends-on = dropbear-keys
            "%,
  "dropbear-keys" = m%"
            type=scripted
            command=/etc/dinit.d/scripts/dropbear-keys.sh
            restart = false
            options = starts-rwfs
            depends-on = early-filesystems

            "%,
  "early-filesystems" = m%"
            type = scripted
            command = /usr/libexec/mount-early
            restart = false
            options = starts-rwfs

            "%,
  filesystems = m%"
            type = scripted
            command = /usr/bin/mount -a
            restart = false
            logfile = /var/log/dinit-filesystems.log
            options = start-interruptible
            start-timeout = 1200   # 20 minutes
            depends-on = udevd
            depends-on = varrw
            waits-for = udev-settle

            "%,
  hostname = m%"
            type = scripted
            command = hostname -F /etc/hostname
            restart = false
            depends-on=early-filesystems
            "%,
  iwd = m%"
            type = process
            command = /usr/libexec/iwd
            depends-on = dbusd
            depends-on = cfg80211
            depends-on = hostname
            logfile = /var/log/iwd-daemon.log
            smooth-recovery = yes
            #env-file=/etc/dinit.d/iwd.env

            "%,
  loadkeys = m%"
            type = scripted
            command = /etc/dinit.d/scripts/loadkeys.sh
            restart = false
            options = start-interruptible
            start-timeout = 1200   # 20 minutes
            depends-on = early-filesystems

            "%,
  loginready = m%"
            type = internal
            restart = false
            options = runs-on-console
            depends-on = filesystems
            depends-on = loadkeys
            waits-for = udevd
            waits-for = syslogd

            "%,
  "netdev-eth0" = m%"
            type = scripted
            command = /usr/bin/ip link set eth0 up
            restart = false
            depends-on = varrw

            "%,
  rcboot = m%"
            type = scripted
            command = /etc/dinit.d/scripts/rcboot.sh
            logfile = /var/log/rcboot.log
            restart = false
            depends-on = varrw
            "%,
  recovery = m%"
            type = process
            command = /usr/bin/sulogin
            options = runs-on-console

            "%,
  seatd = m%"
            type = process
            command = /usr/bin/seatd -g seat
            logfile = /var/log/seatd-daemon.log
            smooth-recovery = true
            waits-for=udev-settle
            depends-on=varrw

            "%,
  syslogd = m%"
            type = process
            smooth-recovery = true
            command = /usr/bin/syslogd -n
            pid-file = /run/syslogd.pid
            options = starts-log

            "%,
  "udev-settle" = m%"
            type = scripted
            command = /usr/bin/udevadm settle
            restart = false
            waits-for = udevd
            waits-for = udev-trigger

            "%,

  "udev-trigger" = m%"
            type = scripted
            command = /usr/bin/udevadm trigger --action=add
            logfile = /run/udev-trigger.log
            restart = false
            depends-on = udevd

            "%,
  udevd = m%"
            type = scripted
            command = /usr/bin/udevd --daemon
            stop-command = /usr/bin/udevadm control -e
            logfile = /run/udevd.log
            restart = false
            depends-on = early-filesystems
            "%,
  varrw = m%"
            type = scripted
            command = /etc/dinit.d/scripts/varrw.sh
            restart = false
            options = starts-rwfs
            logfile = /run/rootrw.log
            depends-on = early-filesystems
            depends-on = udevd
            "%,
}
in
let scripts = {
  "dropbear-keys.sh" = m%"
            #!/bin/sh

            export PATH="/usr/bin:/bin"

            mkdir -p /run/dropbear
            dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
            dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
            dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key
            "%,
  "loadkeys.sh" = m%"
            #!/bin/sh -e
            loadkmap < /usr/share/bkeymaps/sv/sv-latin1.bmap
            "%,
  "rcboot.sh" = m%"
            #!/bin/sh -e
            /usr/bin/install -m755 -g messagebus -o messagebus -d /run/dbus
            "%,
  "varrw.sh" = m%"
            #!/bin/sh -e
            mkdir -p /run/var_overlay/upper
            mkdir -p /run/var_overlay/work
            modprobe overlay || /usr/bin/true
            mount -t overlay overlay -o lowerdir=/var,upperdir=/run/var_overlay/upper,workdir=/run/var_overlay/work /var
            "%
}
in

{
  lib,
  dinitServicesV2 | lib.Package
    = {

      preBuildPhase = [
        "install -d -m0755 dinit.d",
        "cd dinit.d",
      ],

      buildPhase =
        (std.record.values (std.record.map (fun k v => "printf \"%{v}\n\" > %{k}") services))
        @ (
          std.array.map
            (fun v =>
              let vn = std.string.from_number v in
              m%"
        printf "
        type = process
        command = /usr/bin/agetty --login-program /usr/bin/crypto-login tty%{vn} linux-c
        restart = true
        depends-on = loginready
        termsignal = HUP
        smooth-recovery = true
        inittab-id = %{vn}
        inittab-line = tty%{vn}
        " > tty%{ vn}
        "%
            )
            [1, 2, 3, 4, 5, 6]
        )
        @ [
          "install -d -m0755 scripts",
          "cd scripts",
        ]
        @ (std.record.values (std.record.map (fun k v => "printf \"%{v}\n\" > %{k}\nchmod +x %{k}") scripts))
        @ [
          "cd ../..",
          "install -d -m0755 dinit",
          "cd dinit",
          "printf \"PATH=/usr/bin:/bin\n\" > environment",
          "cd .."
        ],

      installPhase = [
        "install -d -m0755 ${DEST}/etc",
        "cp -r dinit.d ${DEST}/etc",
        "cp -r dinit ${DEST}/etc",
      ],
    }
}
