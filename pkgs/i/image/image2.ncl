(import "rootfs.ncl")
& {
  lib,
  drvs,
  drvs,
  _rootfs,
  _rootfs2,
  busybox,

  dinitEnv | lib.Package = {
    installPhase = [
      "install -d -m0755  ${DEST}/etc/dinit",
      m%"
      echo '
      PATH=/usr/bin:/bin
      SYSTEMD_LOG_LEVEL=debug
      SYSTEMD_LOG_LOCATION=1
      ' > ${DEST}/etc/dinit/environment
      "%,
      #       SYSTEMD_LOG_TARGET=console
    ]
  },

  _neededPkgs = [
    # drvs.linuxFirmware,
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
    drvs.elogind,
    (drvs.dinitEnv & { priority = 1 }),
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
    drvs.sway,
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
    drvs.wlClipboard,
    drvs.slurp,
    drvs.grim,
    drvs.grimshot,
    drvs.fuzzel,
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
    drvs.bluez,

    # drvs.flatpak,
    # drvs.fuse,
    # drvs.gnupg2,
    # drvs.gpgme,
    # drvs.bubblewrap,
    # drvs.podman,
    # drvs.distrobox,
    # drvs.conmon,
    # drvs.crun,
    # drvs.netavark,
  ],

  # TODO: uneccesary paths
  # /usr/share/hypr/wall0.png
  # /usr/share/hypr/wall1.png
  # /usr/lib/python3.12/config-3.12-x86_64-linux-gnu/*.a
  # /usr/lib/python3.12/test/__pycache__/
  # /usr/lib/python3.12/__pycache__/
  # /usr/lib/gtk-3.0/3.0.0/printbackends/libprintbackend-file.so
  # /usr/bin/gtk-builder-tool
  # /usr/bin/gtk-query-im*
  baseImageSmall =
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
        ]
        @ (
          std.array.map
            (fun x => (x & { dest = "rootfs/" }))
            (
              _neededPkgs
            )
        ),
    },
}
