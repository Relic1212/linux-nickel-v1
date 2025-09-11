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
let _services =
  let useUdev = true in
  let enableBluetooth = true in
  let useElogind = true in

  (
    {
      boot | Service = {
        type = "internal",
        "depends-ms" = ["tty1", "tty2"] @ (if useElogind then ["elogind"] else ["seatd"]),

        "waits-for" =
          [
            "dbusd",
            # "dhcpcd",
            "iwd",
            "make-shared-root",
            "mount-others",
            "earlyoom",
            #"dropbear",
            "upowerd",
            "power-profiles-daemon",
            # "v4l2loopback",
            "netdev",
            "netdev-lo",
          ]
          @ (
            if enableBluetooth then
              [
                "bluetooth"
              ]
            else
              []
          ),
      },

      cfg80211 = {
        type = "scripted",
        command = "/usr/bin/modprobe cfg80211",
        # command = "/usr/bin/modprobe -a cfg80211 iwlmvm",
        #
        restart = false,
        "depends-on" = ["early-filesystems"],
      },
      dbusd = {
        type = "process",
        command = "/usr/bin/dbus-daemon --system --nofork --nopidfile --print-address=4",
        "depends-on" = ["rcboot"],
        logfile = "/var/log/dbus-daemon.log",
        ready-notification = "pipefd:4",
        smooth-recovery = "yes",
      },

      dhcpcd = {
        type = "process",
        command = "/usr/bin/dhcpcd -B -M", #" --logfile /var/log/dhcpcd-service.log",
        logfile = "/var/log/dhcpcd.log",
        restart = false,
        "depends-on" = [
          "varrw",
          "hostname",
          "udevd",
        ],
        "waits-for" = [
          "netdev",
          "udev-settle",
        ]
      },

      dropbear = {
        type = "process",
        command = "/usr/bin/dropbear -E -F -P /run/dropbear.pid -R",
        logfile = "/var/log/dropbear.log",
        "waits-for" = [
          #"dhcpcd",
          "dropbear-keys"
        ],
      },

      "dropbear-keys" = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/dropbear-keys.sh",
        restart = false,
        options = "starts-rwfs",
        "depends-on" = ["early-filesystems"],
      },

      "early-filesystems" = {
        type = "scripted",
        command = "/usr/libexec/mount-early",
        restart = false,
        options = "starts-rwfs",
      },
      earlyoom = {
        type = "process",
        command = "/usr/bin/earlyoom",
        logfile = "/var/log/earlyoom.log",
        "waits-for" = [
          "zram-init",
          "varrw"
        ],
      },
      filesystems = {
        type = "scripted",
        command = "/usr/bin/mount -a",
        restart = false,
        logfile = "/var/log/dinit-filesystems.log",
        "options" = "start-interruptible",
        "start-timeout" = "1200", # 20 minutes
        "depends-on" = [
          "udevd",
          "varrw"
        ],
        "waits-for" = ["udev-settle"],
      },

      greetd = {
        # https://aur.archlinux.org/cgit/aur.git/tree/greetd?h=greetd-artix-dinit
        type = "process",
        command = "/usr/bin/greetd",
        "depends-on" = ["loginready", "greetd-apply-perms"],
        "smooth-recovery" = "true",
        logfile = "/var/log/greetd.log"
      },

      "greetd-apply-perms" = {
        type = "scripted",
        command = "chown -R greeter:greeter /var/lib/greeter",
        "depends-on" = ["varrw"],
      },

      hostname = {
        type = "scripted",
        # command = m%"/usr/bin/hostname \$(cat /etc/hostname)"%,
        command = m%"/usr/bin/hostname linux"%,

        restart = false,
        depends-on = ["early-filesystems"],
      },

      iwd = {
        type = "process",
        command = "/usr/libexec/iwd",
        "depends-on" = [
          "dbusd",
          "cfg80211",
          " hostname",
          "udevd"
        ],
        "waits-for" = ["udev-settle"],

        logfile = "/var/log/iwd-daemon.log",
        "smooth-recovery" = "yes",
      },

      loadkeys = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/loadkeys.sh",
        restart = false,
        options = "start-interruptible",
        "start-timeout" = "1200", # 20 minutes
        "depends-on" = ["early-filesystems"],
      },

      loginready = {
        type = "internal",
        restart = false,
        options = "runs-on-console",
        "depends-on" = ["filesystems"],
        "waits-for" =
          [
            # "udevd",
            "syslogd",
            "loadkeys",
            "create-x11-socket",
          ]
          @ (if useElogind then ["elogind"] else []),
      },
      "make-shared-root" = {
        type = "scripted",
        command = "/usr/bin/mount --make-shared /",
        restart = false,
        "depends-on" = ["varrw"],
      },
      "mount-others" = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/mount-other.sh",
        restart = false,

        "depends-on" = [
          "udevd",
        ],
        "waits-for" = [
          "udev-settle",
        ]
      },
      "netdev" = {
        type = "scripted",
        command = "/usr/bin/ip link set group 0 up",
        restart = false,
        "depends-on" = ["varrw"],
      },
      "netdev-lo" = {
        type = "scripted",
        command = "/usr/bin/ip link set lo up",
        restart = false,
        "depends-on" = ["varrw"],
      },
      # "netdev-eth0" = {
      #   type = "scripted",
      #   command = "/usr/bin/ip link set eth0 up",
      #   restart = false,
      #   "depends-on" = ["varrw"],
      # },
      #    "netdev-ens2" = {
      #   type = "scripted",
      #   command = "/usr/bin/ip link set ens2 up",
      #   restart = false,
      #   "depends-on" = ["varrw"],
      # },

      rcboot = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/rcboot.sh",
        logfile = "/var/log/rcboot.log",
        restart = false,
        "depends-on" = ["varrw"],
      },

      recovery = {
        type = "process",
        command = "/usr/bin/sulogin",
        options = "runs-on-console"
      },

      rtkit = {
        type = "process",
        command = "/usr/libexec/rtkit-daemon",
        "depends-on" = [
          "dbusd"
        ],
        logfile = "/var/log/rtkit-daemon.log",
      },

      seatd = {
        type = "process",
        command = "/usr/bin/seatd -g seat",
        logfile = "/var/log/seatd-daemon.log",
        smooth-recovery = true,
        "waits-for" =
          if useUdev then
            [
              "udev-settle",
              # "mdevd-coldplug",
            ]
          else
            [
              "mdevd-coldplug",
            ],
        "depends-on" =
          [
            "varrw",
            # "udevd"
            # "mdevd",
          ]
          @ (
            if useUdev then
              [
                "udevd"
              ]
            else
              [
                "mdevd"
              ]
          ),
      },

      # syslogd = {
      #   type = "process",
      #   "smooth-recovery" = true,
      #   command = "/usr/bin/syslogd -n",
      #   "pid-file" = "/run/syslogd.pid",
      #   options = "starts-log",
      # },

      syslogd = {
        type = "process",
        "smooth-recovery" = true,
        command = "/usr/bin/metalog",
        "depends-on" = [
          "varrw",
        ],
        "pid-file" = "/var/run/syslogd.pid",
        # "log-type" = "buffer",
        options = "starts-log",
      },
      upowerd = {
        type = "process",
        command = "/usr/libexec/upowerd",
        "depends-on" =
          [
            "varrw",
          ]
          @ (if useElogind then ["elogind"] else []),
        logfile = [
          "/var/log/upowerd.log"
        ]
      },

      "power-profiles-daemon" = {
        type = "process",
        command = "/usr/libexec/power-profiles-daemon -v",
        "depends-on" = [
          "upowerd",
          "dbusd"
        ],
        logfile = "/var/log/power-profiles-daemon.log"
      },
      v4l2loopback = {
        type = "scripted",
        command = "/usr/bin/modprobe v4l2loopback devices=2 video_nr=4,10 card_label='MiA3','OBS-Cam' exclusive_caps=1,1",
        restart = false,
        "depends-on" = ["early-filesystems"],
      },

      varrw = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/varrw.sh",
        restart = false,
        options = "starts-rwfs",
        logfile = "/run/rootrw.log",
        "depends-on" = [
          "early-filesystems",
          # "udevd",
        ],
      },
      "zram-init" = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/zram-init.sh",

        restart = false,
        "depends-on" = [
          "early-filesystems",
        ],
      },
      "create-x11-socket" = {
        type = "scripted",
        command = "/etc/dinit.d/scripts/create-x11-socket.sh",

        "depends-on" = [
          "early-filesystems",
        ],
      }
    }
    & (
      if useUdev then
        {

          "udev-settle" = {
            type = "scripted",
            command = "/usr/bin/udevadm settle",
            restart = false,
            "waits-for" = ["udevd", "udev-trigger"],
          },

          # Trigger udev events for already-present devices.
          "udev-trigger" = {
            type = "scripted",
            command = "/usr/bin/udevadm trigger --action=add",
            logfile = "/run/udev-trigger.log",
            restart = false,
            "depends-on" = ["udevd"],
          },

          udevd = {
            type = "scripted",
            command = "/usr/bin/udevd --daemon",
            "stop-command" = "/usr/bin/udevadm control -e",
            logfile = "/run/udevd.log",
            restart = false,
            depends-on = "early-filesystems",
          },
        }
      else
        {
          mdevd = {
            type = "process",
            command = "/usr/bin/mdevd -v3",
            "depends-on" = [
              "early-filesystems"
            ],
            logfile = "/run/mdevd.log",
          },
          "mdevd-coldplug" = {
            type = "scripted",

            command = "/usr/bin/mdevd-coldplug",
            "depends-on" = ["mdevd"],
          },
        }
    )
    & (
      if enableBluetooth then
        {
          bluetooth = {
            type = "process",
            command = "/usr/libexec/bluetooth/bluetoothd -n",
            logfile = "/var/log/bluetooth.log",
            "smooth-recovery" = "true",
            "depends-on" = [
              "udevd",
              "varrw",
              "dbusd",
              "filesystems",
            ],
            "waits-for" = ["udev-settle"],
          }
        }
      else
        {}
    )
    & (
      if useElogind then
        {
          elogind = {
            type = "process",
            command = "/usr/libexec/elogind",
            logfile = "/var/log/elogind.log",
            smooth-recovery = "yes",

            "depends-on" = [
              "dbusd",
              "udevd",
              "varrw",
            ],
            "waits-for" = [
              "udev-settle",
            ]
          }
        }
      else
        {}
    )
  )
in

let services = (std.record.map (fun k v => serviceToString v) _services)
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
  # "loadkeys.sh" = m%"
  #           #!/bin/sh -e
  #           loadkmap < /usr/share/bkeymaps/sv/sv-latin1.bmap
  #           "%,
  "loadkeys.sh" = m%"
            #!/bin/sh -e
            loadkeys sv-latin1
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
            "%,
  # echo "$(head -n1 /proc/meminfo | rev |cut -d ' ' -f2 | rev)KiB"
  "zram-init.sh" = m%"
#!/bin/sh -e
/usr/bin/modprobe zram || true
/usr/bin/zramctl /dev/zram0 --size "32GiB"
/usr/bin/mkswap -U clear /dev/zram0
/usr/bin/swapon --discard --priority 100 /dev/zram0
  "%,
  "create-x11-socket.sh" = m%"
#!/bin/sh -e
mkdir -p /tmp/.X11-unix
chmod 1777 /tmp/.X11-unix
"%
}
in

{
  lib,
  dinitServicesV3 | lib.Package = {

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
        "printf \"lang=en_US.UTF8\n\" >> environment",
        "cd .."
      ],

    installPhase = [
      "install -d -m0755 ${DEST}/etc",
      "cp -r dinit.d ${DEST}/etc",
      "cp -r dinit ${DEST}/etc",
    ],
  }
}
