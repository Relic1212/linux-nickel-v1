(import "rootfs.ncl")
& (import "image2.ncl")
& {
  lib,
  drvs,
  drvs,
  _rootfs,
  _rootfs2,
  busybox,
  busyboxFinal = busybox & { postInstallPhase = ["rm ${DEST}/usr/bin/modprobe"] },
  dashSh | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/bin",
      "cd ${DEST}/bin",
      "ln -s /usr/bin/dash sh",
    ]
  },
  emptyStty | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/bin",
      "cd ${DEST}/bin",
      "ln -s /usr/bin/true stty",
    ]
  },
  baseBaseRootfs = (
    _rootfs
    & {

      options = {
        full = (true),
        hasX11 = true,
        haveContainers = (true),
        isVm = (false),
      },
      name = "base-base-rootfs",
      biDrvs =
        (
          if options.isVm then
            []
          else
            [
              drvs.linuxFirmware,
            ]
        )
        @ [
          # base
          # drvs.busyboxFinal,

          ## begin bsdutils
          # drvs.bsdutils,
          ## end bsdutils

          ## begin uutils
          drvs.uutils,
          drvs.uutilsSymlinks,
          drvs.uutilsFindutils,
          drvs.gnused,
          drvs.gnugrep,
          (drvs.sbase & { priority = -1 }),
          # (drvs.utilLinux & { priority = -1 }),
          drvs.libarchive,
          drvs.wget,
          drvs.bzip2,
          ## end uutils

          ## begin sbase
          #drvs.sbase,
          #(drvs.emptyStty & { priority = 10 }),
          #(drvs.ubase & { priority = -1 }),
          ## end sbase
          # drvs.vis,
          drvs.gitFull,
          drvs.vim,
          drvs.bc,
          drvs.dash,
          drvs.dashSh,
          drvs.iproute2,
          (drvs.kbd & { priority = -1 }),
          drvs.pigz,
          drvs.curl,
          drvs.metalog,
          #drvs.zsh,
          drvs.fish,
          drvs.mawk,
          drvs.ncurses,
          (drvs.basefiles & { priority = 1 }),
          drvs.dinit,
          drvs.dinitServicesV3,
          drvs.dinitUtils,
          drvs.shadow,
          drvs.libcap,
          drvs.utilLinux,
          drvs.pciutils,
          drvs.xz,
          # drvs.linux,
          drvs.linuxFedora,

          # drvs.v4l2loopback,

          # drvs.linuxFirmwareSmaller,
          drvs.eudev,
          # drvs.mdevd,
          # drvs.mdevdConf,
          drvs.dbus,
          drvs.bkeymaps,
          drvs.kmod,
          drvs.keyutils,
          drvs.mandoc,
          drvs.less,
          # drvs.checkFirmware,
          drvs.jq,
          drvs.earlyoom,
          # net
          drvs.dhcpcd,
          drvs.iwd,
          drvs.dropbear,
          drvs.openssh,
          drvs.openresolv,
          drvs.caCertificates,

          # enc
          drvs.e2fsprogs,
          # drvs.fscryptUnlockHome,
          drvs.fscryptUnlockHomeElogind,
          # drvs.elogind,
          drvs.polkit,
          drvs.elogindWithPolkit,
          # drvs-basu,
          drvs.openssl,
          drvs.fscrypt,

          # gui
          drvs.seatd,
          #drvs.sway,
          drvs.libinput,
          drvs.libxkbcommon,
          drvs.libx11,
          drvs.libdrm,
          drvs.xkeyboardConfig,
          drvs.xdgRuntimeRun,
          drvs.foot,
          drvs.fontconfig,
          drvs.ttfCroscore,
          drvs.fontAwesome,
          drvs.dejavuFonts,
          drvs.hicolorIconTheme,
          drvs.terminusFont,
          drvs.symbolsNerdFont,
        ]
        @ (
          if options.hasX11 then
            [
              drvs.sway,
              # drvs.scroll,
              # drvs.swayfx,
              # drvs.mwc,
              #drvs.xwayland,
              #drvs.xkbcomp,
              drvs.hyprland,
              drvs.hyprpaper,
              drvs.hyprpicker,
              drvs.hyprlandContrib,
              drvs.niri,

              # ### QT
              # drvs.qtdeclarative,
              # drvs.qtbase,
              # drvs.qtshadertools,
              # drvs.qtwayland,
              # # drvs.hyprlandQtSupport,
              # # drvs.hyprlandQtutils,
              # drvs.qt5compat,
              drvs.quickshell,
              drvs.ddcutil,
              drvs.lmSensorsSensors,

              ## -QT
            ]
          else
            [
              drvs.sway,
            ]
        )
        @ (
          (
            if options.full then
              [
                # drvs.kwallet,
                # drvs.qca,
                #drvs.cagebreak,
                drvs.rwaybar,
                drvs.brightnessctl,
                drvs.mako,
                # drvs.basu,
                drvs.libnotify,
                drvs.strace,
                #drvs.dwl,
                drvs.psmisc,
                #drvs.uutilsProcps,
                #drvs.uutilsProcpsSymlinks,
                drvs.procps,
                drvs.wob,
                # drvs.wmenu,
                drvs.dmenuWayland,
                drvs.sov,
                drvs.swayidle,
                drvs.swaylock,
                drvs.swaybg,
                drvs.breezeIcons,
                drvs.wlClipboard,
                drvs.slurp,
                drvs.grim,
                drvs.grimshot,
                # drvs.wfRecorder,
                drvs.j4MenuDesktop,
                drvs.lavalauncher,
                # drvs.rofiWayland,
                drvs.rofi,
                drvs.fuzzel,
                drvs.waybar,
                # drvs.eww,
                drvs.thunar,
                drvs.gammastep,
                drvs.gebaarLibinput,
                drvs.upower,
                drvs.acpid,
                drvs.laptopModeTools,
                #drvs.tuned,
                drvs.opendoas,
                drvs.rsync,
                drvs.file,
                drvs.ripgrep,
                # alsa
                (drvs.alsaFirmware & { priority = -1 }),
                drvs.alsaLibs,
                drvs.alsaUtils,
                # pw (EXP!)
                drvs.pipewire,
                drvs.lua,
                drvs.xdgDesktopPortal,
                drvs.xdgDesktopPortalWlr,
                drvs.xdgDesktopPortalGtk,
                drvs.pulseaudioBin,
                drvs.playerctl,
                # bt
                drvs.bluez,
                #drvs.blueAlsa,
                #drvs.bluez4,
                # drvs.pulseaudio14,
                # flatpak
                drvs.xdgUtils,
                drvs.xdgDbusProxy,
                drvs.mountOthers,
                drvs.sbctl,
                drvs.pythonFull,
                # drvs.autotiling,
                # drvs.i3ipcPython,
                drvs.tzdata,
                # drvs.sndiod,
                drvs.desktopFileUtils,
                drvs.squeekboard,
                drvs.lisgd,
                drvs.glib,
                drvs.gsettingsDesktopSchemas,
                drvs.gnomeDesktop,
                drvs.atSpi2Core,
                drvs.gnomeKeyring,
                drvs.gcr,
                drvs.gtk3,
                # drvs.ptyxis,
                # drvs.libadwaita,
                # drvs.vte,
                # drvs.gnomeTerminal,
                # drvs.libhandy,
                drvs.cliphist,
                drvs.inotifyTools,
                drvs.btop,
                drvs.starship,
                drvs.papyrusIconTheme,
                drvs.socat,
                drvs.pv,
                drvs.cava,
                drvs.adwGtk3,
                drvs.swappy,
                drvs.wezterm,

                # ttyescape
                drvs.buffybox,
                drvs.hkdm,
                drvs.ttyescape,
                # drvs.wld,
                # drvs.swc,
                # drvs.velox,
                # drvs.stWayland,

                ### nwg
                drvs.nwgDrawer,
                drvs.nwgLook,
                ### -nwg
                drvs.yad,
              ]
            else
              []
          )
          @ (
            if options.haveContainers then
              [
                drvs.flatpak,
                drvs.fuse,
                drvs.gnupg2,
                drvs.gpgme,
                drvs.bubblewrap,
                drvs.podman,
                drvs.distrobox,
                drvs.conmon,
                drvs.crun,
                drvs.netavark,
              ]
            else
              []
          )
        )
    }
  ),

  _cosmicPackages = [
    drvs.bash,
    drvs.cosmicApplets,
    drvs.cosmicApplibrary,
    drvs.cosmicBg,
    drvs.cosmicComp,
    drvs.cosmicIcons,
    drvs.cosmicLauncher,
    drvs.cosmicNotifications,
    drvs.cosmicOsd,
    drvs.cosmicPanel,
    drvs.cosmicPopLauncher,
    drvs.cosmicSession,
    drvs.cosmicSettings,
    drvs.cosmicSettingsDaemon,
    drvs.cosmicWorkspacesEpoch,
  ],

  cosmicPackages | lib.Package = {
    biDrvs = _cosmicPackages
  },

  # TODO: uneccesary paths
  # /usr/share/hypr/wall0.png
  # /usr/share/hypr/wall1.png
  # /usr/lib/python3.12/config-3.12-x86_64-linux-gnu/*.a
  # /usr/lib/python3.12/test/__pycache__/
  # /usr/lib/python3.12/__pycache__/
  # /usr/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-file.so
  # /usr/bin/gtk-builder-tool
  # /usr/bin/gtk-query-im*
  baseImage =
    _rootfs2
    & {
      enableCcache = false,
      name = "base-image",
      biDrvs =
        [
          # drvs.baseBaseRootfs,
          drvs.erofsUtils,
          drvs.mtools,
          drvs.genimage,
          drvs.cryptsetup,
          drvs.systemdBoot,
          drvs.llvm, # objdump
          drvs.pythonFull,
          drvs.utilLinux,
          drvs.rsync,
        ]
        @ (
          std.array.map
            (fun x => (x & { dest = "rootfs/" }))
            (
              baseBaseRootfs.biDrvs
              # @ _cosmicPackages
            )
        ),
    },

  vmImage =
    baseImage
    & {
      installPhase = [
        "mkdir -p /tmp/workdir/out/efipart/EFI/BOOT",
        "mkdir -p /tmp/workdir/out/efipart/EFI/loader",
        "cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /tmp/workdir/out/efipart/EFI/BOOT/bootx64.efi",
        "echo \"timeout 5\n\" >  /tmp/workdir/out/efipart/EFI/loader/loader.conf",
        "dd if=/dev/zero of=/tmp/workdir/out/image/efipart.vfat bs=224M count=1",
        "mkfs.vfat /tmp/workdir/out/image/efipart.vfat",
        "mcopy -s -i  /tmp/workdir/out/image/efipart.vfat  /tmp/workdir/out/efipart/EFI ::/",
        "python /tmp/workdir/files/write_partitions.py --partauuid aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
      ],

      extraFiles = [
        {
          file = "write_partitions.py",
          sha256sum = "b55fd7c30c96b851b2354c6b163a881261fe603dd855cf1db4f0eef353fea087"
        }
      ]
    },

  aarch64Image | lib.Package = {
    biDrvs = [
      # drvs.busyboxAarch64,
      drvs.dashAarch64,
      drvs.dashSh,
      drvs.linuxAarch64,
      drvs.basefiles,
      drvs.erofsUtils,
      drvs.basefilesAarch64,
    ],
    buildPhase = [
      m%"
          mkfs.erofs \
              -d 1 \
              -L aarch6-root \
                  \
              ${DEST}/aarch64-root.img /aarch64-unknown-linux-musl/
            "%
    ],
  }
}
