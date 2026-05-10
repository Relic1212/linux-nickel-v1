{
  lib,
  drvs,
  _rootfs2,
  niriImage =
    _rootfs2
    & {
      enableCcache = false,
      name = "base-image",
      options = {
        full = (true),
        hasX11 = true,
        haveContainers = (true),
        isVm = (false),
        utilsBsd = [
          drvs.bsdutils,
          (drvs.sbase & { priority = -1 }),
        ],
        utilsUu = [
          drvs.uutils,
          drvs.uutilsSymlinks,
          drvs.uutilsFindutils,
        ],
        utilsBb = [
          drvs.busyboxFinal,
        ],
        utilsSbase = [
          (drvs.gnugrep & { priority = 1 }),
          (
            drvs.uutilsFindutils & { priority = 1 }
          ),
          drvs.sbase,
          (drvs.ubase & { priority = -1 }), # df
          drvs.emptyStty,
        ],

        utils = utilsSbase,
      },
      biDrvs = (
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
              (
                if options.isVm then
                  []
                else
                  [
                    drvs.linuxFirmware,
                  ]
              )
              @ (options.utils)
              @ [
                # base
                # drvs.busyboxFinal,

                ## begin bsdutils
                # drvs.bsdutils,
                ## end bsdutils

                ## begin uutils
                # drvs.uutils,
                # drvs.uutilsSymlinks,
                # drvs.uutilsFindutils,
                # drvs.gnused,
                # drvs.gnugrep,
                # (drvs.sbase & { priority = -1 }),
                # (drvs.utilLinux & { priority = -1 }),
                (drvs.libarchive & { priority = 1 }),
                drvs.wget,
                drvs.bzip2,
                ## end uutils

                ## begin sbase
                #drvs.sbase,
                #(drvs.emptyStty & { priority = 10 }),
                #(drvs.ubase & { priority = -1 }),
                ## end sbase
                # drvs.vis,
                (drvs.usbutils & { priority = 1 }),
                drvs.hwdata,
                drvs.lshw,
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
                # drvs.fish,
                drvs.fish4Cmake,
                drvs.mawk,
                drvs.ncurses,
                (drvs.basefiles & { priority = 1 }),
                drvs.dinit,
                drvs.dinitServicesV3,
                drvs.dinitUtils,
                drvs.shadowPam,
                drvs.libpam,
                drvs.fscryptUnlockHome,
                drvs.cryptoPam,
                drvs.greetd,
                # drvs.gtkgreet,
                (drvs.gtkgreetSwayConf & { priority = 1 }),
                drvs.tuigreet,
                drvs.tuigreetConfig,
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
                # drvs.fscryptUnlockHomeElogind,
                # drvs.elogind,
                drvs.polkit,
                drvs.elogindWithPolkit,
                # drvs.openrcSettingsd,
                # drvs.openntpd,
                # drvs-basu,
                drvs.openssl,
                drvs.fscrypt,

                # gui
                # drvs.seatd,
                #drvs.sway,
                drvs.libinput,
                drvs.libxkbcommon,
                drvs.libx11,
                drvs.libdrm,
                drvs.xkeyboardConfig,
                drvs.xdgRuntimeRun,
                # drvs.foot,
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
                    # drvs.sway,
                    # drvs.scroll,
                    # drvs.swayfx,
                    # drvs.mwc,
                    drvs.xwayland,
                    drvs.xkbcomp,
                    # drvs.hyprlandX11,
                    # drvs.hyprpaper,
                    # drvs.hyprpicker,
                    # drvs.hyprlandContrib,
                    drvs.niri,
                    drvs.xwaylandSatellite,
                    # drvs.niriNsticky,
                    # drvs.niriSessionManager,
                    # drvs.nirinit,
                    # drvs.nirius,
                    # drvs.swaytreesave,
                    # drvs.stasis,
                    # drvs.system76Scheduler,
                    # drvs.mwc,
                    # drvs.mangowc,

                    # ### QT
                    # drvs.qtdeclarative,
                    # drvs.qtbase,
                    # drvs.qtshadertools,
                    # drvs.qtwayland,
                    # # drvs.hyprlandQtSupport,
                    # # drvs.hyprlandQtutils,
                    # drvs.qt5compat,
                    drvs.quickshell,
                    drvs.danklinuxDgop,
                    drvs.danklinuxDms,
                    drvs.ddcutil,
                    drvs.lmSensorsSensors,
                    drvs.androidTools,
                    drvs.androidUdevRules,
                    drvs.kanshi,
                    # drvs.iwmenu,
                    # drvs.iwgtk,
                    # drvs.impala,

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
                      #   drvs.rwaybar,
                      drvs.brightnessctl,
                      #   drvs.mako,
                      # drvs.basu,
                      drvs.libnotify,
                      drvs.strace,
                      #drvs.dwl,
                      drvs.psmisc,
                      #drvs.uutilsProcps,
                      #drvs.uutilsProcpsSymlinks,
                      drvs.procps,
                      #   drvs.wob,
                      # drvs.wmenu,
                      #   drvs.dmenuWayland,
                      #   drvs.sov,
                      #   drvs.swayidle,
                      #   drvs.swaylock,
                      #   drvs.swaybg,
                      drvs.breezeIcons,
                      drvs.wlClipboard,
                      #   drvs.slurp,
                      #   drvs.grim,
                      #   drvs.grimshot,
                      # drvs.wfRecorder,
                      #   drvs.j4MenuDesktop,
                      #   drvs.lavalauncher,
                      # drvs.rofiWayland,
                      #   drvs.rofi,
                      #   drvs.fuzzel,
                      #   drvs.waybar,
                      #   drvs.eww,
                      drvs.thunar,
                      #   drvs.gammastep,
                      #   drvs.wlsunset,
                      #   drvs.gebaarLibinput,
                      drvs.upower,
                      drvs.acpid,
                      #   drvs.laptopModeTools,
                      drvs.powertop,
                      #   drvs.tlp,
                      #   drvs.perl,
                      drvs.hdparm,
                      drvs.powerProfilesDaemon,
                      drvs.iw,
                      drvs.ethtool,
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
                      drvs.xdgDesktopPortalGnome,
                      drvs.pulseaudioBin,
                      drvs.playerctl,
                      drvs.rtkit,
                      # bt
                      drvs.bluez,
                      #drvs.blueAlsa,
                      #drvs.bluez4,
                      # drvs.pulseaudio14,
                      # flatpak
                      drvs.xdgUtils,
                      drvs.xdgUserDirs,
                      drvs.xdgDbusProxy,
                      drvs.mountOthers,
                      drvs.sbctl,
                      # drvs.pythonFull,
                      drvs.pythonInteractive,
                      # drvs.autotiling,
                      # drvs.i3ipcPython,
                      drvs.tzdata,
                      # drvs.sndiod,
                      drvs.desktopFileUtils,
                      drvs.squeekboard,
                      # drvs.udisks,
                      # drvs.fwupd,
                      #   drvs.ananicyCpp,
                      #   drvs.ananicyRulesCachyos,
                      # drvs.sysboard,
                      #   drvs.lisgd,
                      drvs.glib,
                      drvs.gsettingsDesktopSchemas,
                      drvs.gnomeDesktop,
                      drvs.atSpi2Core,
                      drvs.gnomeKeyring,
                      drvs.gcr,
                      drvs.gtk3,
                      # drvs.ptyxis,
                      # drvs.libadwaitaShared_181,
                      # drvs.vte,
                      # drvs.gnomeTerminal,
                      # drvs.libhandy,
                      drvs.cliphist,
                      drvs.inotifyTools,
                      drvs.btop,
                      drvs.htop,
                      drvs.starship,
                      drvs.bat,
                      drvs.papyrusIconTheme,
                      drvs.geoclue,
                      drvs.socat,
                      drvs.pv,
                      drvs.cava,
                      drvs.adwGtk3,
                      # drvs.swappy,
                      drvs.wezterm,
                      drvs.micro,
                      # ttyescape

                      ### nwg
                      # drvs.nwgDrawer,
                      # drvs.nwgLook,
                      # ### -nwg
                      # drvs.yad,
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
            )
        )
      )
    },
}
