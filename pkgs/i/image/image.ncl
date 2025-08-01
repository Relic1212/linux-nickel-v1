(import "rootfs.ncl")
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
          #drvs.gnused,
          #drvs.gnugrep,
          (drvs.sbase & { priority = -1 }),
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
          drvs.basefiles,
          drvs.dinit,
          drvs.dinitServicesV3,
          drvs.dinitUtils,
          drvs.shadow,
          drvs.libcap,
          drvs.utilLinux,
          drvs.pciutils,
          drvs.xz,
          #drvs.linux,
          drvs.v4l2loopback,

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
          drvs.openresolv,
          drvs.caCertificates,

          # enc
          drvs.e2fsprogs,
          drvs.fscryptUnlockHome,
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
          # drvs.fontAwesome,
          drvs.dejavuFonts,
          drvs.hicolorIconTheme,
          drvs.terminusFont,
        ]
        @ (
          if options.hasX11 then
            [
              drvs.swayX11,
              drvs.scroll,
              # drvs.swayfx,
              drvs.mwc,
              drvs.xwayland,
              drvs.xkbcomp,
              drvs.hyprlandX11,
              drvs.hyprpaper,
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
                #drvs.cagebreak,
                drvs.rwaybar,
                drvs.brightnessctl,
                drvs.mako,
                drvs.basu,
                drvs.libnotify,
                drvs.strace,
                #drvs.dwl,
                drvs.psmisc,
                #drvs.uutilsProcps,
                #drvs.uutilsProcpsSymlinks,
                drvs.procps,
                drvs.wob,
                drvs.wmenu,
                drvs.dmenuWayland,
                drvs.sov,
                drvs.swayidle,
                drvs.swaylock,
                drvs.swaybg,
                drvs.wlClipboard,
                drvs.slurp,
                drvs.grim,
                drvs.grimshot,
                drvs.wfRecorder,
                drvs.j4MenuDesktop,
                drvs.lavalauncher,
                drvs.waybar,
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
                # bt
                drvs.bluez,
                #drvs.blueAlsa,
                #drvs.bluez4,
                # drvs.pulseaudio14,
                # flatpak
                drvs.xdgDbusProxy,
                drvs.mountOthers,
                drvs.sbctl,
                drvs.pythonFull,
                drvs.autotiling,
                drvs.i3ipcPython,
                drvs.tzdata,
                drvs.sndiod,
                drvs.desktopFileUtils,
                drvs.squeekboard,
                drvs.lisgd,
                drvs.glib,
                drvs.gsettingsDesktopSchemas,
                drvs.gnomeDesktop,
                drvs.atSpi2Core,

                # drvs.hyprlandQtSupport,
                # drvs.hyprlandQtutils,

                # ttyescape
                drvs.buffybox,
                drvs.hkdm,
                drvs.ttyescape,
                drvs.wld,
                drvs.swc,
                drvs.velox,
                drvs.stWayland,
              ]
            else
              []
          )
          @ (
            if options.haveContainers then
              [
                drvs.flatpak,
                drvs.gnupg2,
                drvs.gpgme,
                drvs.bubblewrap,
                drvs.podman,
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
  baseImage =
    _rootfs2
    & {
      enableCcache = false,
      name = "base-image",
      biDrvs = [
        drvs.baseBaseRootfs,
        drvs.erofsUtils,
        drvs.mtools,
        drvs.genimage,
        drvs.cryptsetup,
        drvs.systemdBoot,
        drvs.llvm, # objdump
        drvs.pythonFull,
        drvs.utilLinux,
      ]
    },

  vmImage | lib.Package =
    baseImage
    & {
      name | priority 1 = "vm-image",
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
