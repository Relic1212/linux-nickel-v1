(import "rootfs.ncl")
& (import "image2.ncl")
& {
  lib,
  drvs,
  drvs,
  _rootfs,
  _rootfs2,
  busybox,
  busyboxMimalloc =
    busybox
    & {
      useMimalloc = true,
      biDrvs | priority 1 = busybox.biDrvs @ [drvs.mimalloc],
    },
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
      "install -d -m0755 ${DEST}/usr/bin",
      "cd ${DEST}/usr/bin",
      "ln -s true stty",
    ]
  },
  _baseBaseRootfs = (
    _rootfs
    & {

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
          drvs.gnugrep & { priority = 1 },
          drvs.gnused & { priority = 1 },
          drvs.uutilsFindutils & { priority = 1 },
          drvs.sbase,
          drvs.ubase & { priority = -1 }, # df
          drvs.emptyStty,
          drvs.lsof,
        ],

        utils = utilsSbase,
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
          drvs.zsh,
          # drvs.fish,
          drvs.fish4Cmake,
          drvs.mawk,
          drvs.ncurses,
          (drvs.basefiles & { priority = 1 }),
          drvs.etcSkel,
          drvs.dinit,
          drvs.dinitServicesV3,
          drvs.dinitUtils,
          drvs.shadowPam,
          drvs.libpam,
          drvs.fscryptUnlockHome,
          drvs.cryptoPam,
          drvs.greetd,
          drvs.gtkgreet,
          (drvs.gtkgreetSwayConf & { priority = 1 }),
          drvs.tuigreet,
          drvs.tuigreetConfig,
          drvs.libcap,
          drvs.utilLinux,
          drvs.pciutils,
          drvs.hwinfo,
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
          drvs.dnsmasq,
          drvs.networkmanager,
          drvs.networkManagerApplet,
          drvs.nftables,
          drvs.iputils,
          drvs.netcatOpenbsd,

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
          drvs.tpm2Tools,
          drvs.gocryptfs,

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
          # drvs.notoFonts,
        ]
        @ (
          if options.hasX11 then
            [
              drvs.sway,
              # drvs.scroll,
              # drvs.cwcwm,
              # drvs.swayfx,
              drvs.xwayland,
              drvs.xkbcomp,
              drvs.hyprlandWithPlugins,
              # drvs.hyprland,
              drvs.hyprlandGuiutils,
              drvs.hyprlauncher,
              drvs.hyprpaper,
              drvs.hyprpicker,
              drvs.hyprlandContrib,
              drvs.hyprlock,
              # drvs.fhtCompositor,
              drvs.niri,
              drvs.xwaylandSatellite,
              drvs.niriNsticky,
              drvs.niriSessionManager,
              drvs.nirinit,
              drvs.nirius,
              drvs.niriTag,
              drvs.niriSidebar,
              drvs.niriSwitch,
              drvs.swaytreesave,
              drvs.stasis,
              drvs.system76Scheduler,
              drvs.system76SchedulerNiri,
              drvs.ashell,
              drvs.ironbar,
              drvs.swaync,
              drvs.noctalia,
              drvs.satty,
              drvs.fastfetch,
              # drvs.miri,
              # drvs.mwc,
              drvs.mangowc,
              # drvs.river,

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
              drvs.iwgtk,
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
                # drvs.rwaybar,
                drvs.brightnessctl,
                drvs.mako,
                # drvs.basu,
                drvs.libnotify,
                drvs.strace,
                #drvs.dwl,
                drvs.dconf,
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
                # drvs.breezeIcons,
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
                drvs.gammad,
                drvs.wlsunset,
                drvs.wlMirror,
                drvs.gebaarLibinput,
                drvs.ydotool,
                drvs.waycorner,
                drvs.wayEdges,
                drvs.wtype,
                drvs.wlrctl,
                drvs.xremap,
                drvs.keyd,
                drvs.keydConfig,
                drvs.mkoverlay,
                drvs.upower,
                drvs.acpid,
                drvs.laptopModeTools,
                drvs.powertop,
                drvs.xset,
                drvs.tlp,
                drvs.perl,
                drvs.hdparm,
                drvs.powerProfilesDaemon,
                drvs.iw,
                drvs.ethtool,
                drvs.linuxTools,
                drvs.ryzenAdj,
                # drvs.tuned,
                drvs.opendoas,
                drvs.rsync,
                drvs.file,
                drvs.ripgrep,
                drvs.wev,
                drvs.evtest,
                drvs.nvtop,
                drvs.fd,
                # drvs.freerdp,

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
                drvs.pavucontrol,
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
                drvs.udisks,
                drvs.fwupd,
                drvs.ananicyCpp,
                drvs.ananicyRulesCachyos,
                drvs.sysboard,
                drvs.lisgd,
                drvs.glib,
                drvs.gsettingsDesktopSchemas,
                drvs.gnomeDesktop,
                drvs.atSpi2Core,
                drvs.gnomeKeyring,
                drvs.gcr,
                drvs.gtk3,
                drvs.ptyxis,
                # drvs.libadwaitaShared_181,
                drvs.vte,
                # drvs.gnomeConsole,
                drvs.gnomeTerminal,
                # drvs.libhandy,
                drvs.cliphist,
                # drvs.copyq,
                drvs.cursorClip,
                drvs.inotifyTools,
                drvs.btop,
                drvs.htop,
                drvs.starship,
                drvs.bat,
                drvs.tmux,
                drvs.waypipe,
                drvs.sshfs,
                drvs.mosh,
                drvs.tigervnc,
                drvs.papyrusIconTheme,
                drvs.geoclue,
                drvs.isoCodes,
                drvs.blocaled,
                drvs.socat,
                drvs.pv,
                drvs.parted,
                drvs.cava,
                drvs.adwGtk3,
                drvs.swappy,
                drvs.imv,
                # drvs.wezterm,
                # drvs.konsole,
                drvs.alacritty,
                drvs.micro,
                # ttyescape
                # drvs.buffybox,
                # drvs.hkdm,
                # drvs.ttyescape,
                # drvs.wld,
                # drvs.swc,
                # drvs.velox,
                # drvs.stWayland,

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

                ### podman-compose
                drvs.podmanCompose,
                drvs.pyyaml,
                drvs.pythonDotenv,
                drvs.pythonClick,
                drvs.pythonColorama,
                ### -podman-compose
                drvs.passt,
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
    drvs.cosmicGreeter,
    drvs.cosmicGreeterConfig,
    drvs.cosmicXdgDesktopPortal,
    drvs.cosmicRandr,
    drvs.cosmicIdle,
    drvs.cosmicFiles,
    drvs.cosmicScreenshot,
    drvs.cosmicWallpapers,
    drvs.cosmicTerm,
    drvs.cosmicEdit,
    drvs.cosmicStore,
    drvs.cosmicInitialSetup,
    drvs.cosmicExtAlternativeStartup,
    drvs.cosmicExtExtraSessions,
    drvs.cosmicUtilsClipboardManager,
    drvs.cosmicExtAppletCaffeine,
    drvs.cosmicExtAppletExternalMonitorBrightness,
    drvs.cosmicOsk,
    drvs.cosmicCtl,
    drvs.cosmicPlayer,
    drvs.wkeys,
  ],

  # cosmicPackages | lib.Package = {
  #   biDrvs = _cosmicPackages
  # },
  _pplasmaPackages | lib.Package = {
    biDrvs = _plasmaPackages
  },

  _plasmaPackages = [
    # drvs.attica,
    # drvs.breeze,
    drvs.hunspell,
    # drvs.karchive,
    # drvs.kauth,
    # drvs.kbookmarks,
    # drvs.kcmutils,
    # drvs.kcodecs,
    # drvs.kcolorscheme,
    # drvs.kcompletion,
    # drvs.kconfig,
    # drvs.kconfigwidgets,
    # drvs.kcoreaddons,
    # drvs.kcrash,
    # drvs.kdbusaddons,
    # drvs.kdeclarative,
    # drvs.kdecoration,
    # drvs.kded,
    drvs.kglobalaccel,
    drvs.kglobalacceld,
    # drvs.kguiaddons,
    drvs.kholidays,
    drvs.ki18n,
    # drvs.kiconthemes,
    # drvs.kidletime,
    # drvs.kio,
    # drvs.kirigami,
    # drvs.kitemmodels,
    # drvs.kitemviews,
    # drvs.kjobwidgets,
    # drvs.knewstuff,
    # drvs.knighttime,
    # drvs.knotifications,
    # drvs.knotifyconfig,
    # drvs.kpackage,
    # drvs.kparts,
    # drvs.krunner,
    # drvs.kscreenlocker,
    # drvs.kservice,
    # drvs.kstatusnotifieritem,
    # drvs.ksvg,
    # drvs.ktexteditor,
    # drvs.ktextwidgets,
    # drvs.kunitconversion,
    # drvs.kwallet,
    drvs.kwayland,
    # drvs.kwidgetsaddons,
    drvs.kwin,
    # drvs.kwindowsystem,
    # drvs.kxmlgui,
    drvs.layerShellQt,
    drvs.libkscreen,
    drvs.libksysguard,
    drvs.libplasma,
    # drvs.phonon,
    drvs.plasma5support,
    drvs.plasmaActivities,
    drvs.plasmaActivitiesStats,
    drvs.plasmaWaylandProtocols,
    drvs.plasmaWorkspace,
    drvs.polkitQt6,
    # drvs.prison,
    drvs.qcoro,
    drvs.qtlocation,
    drvs.qtpositioning,
    # drvs.solid,
    # drvs.sonnet,
    drvs.switcherooControl,
    # drvs.syntaxHighlighting,
  ],

  _lxqtPackages = [
    drvs.lxqtSession,
    drvs.liblxqt,
    drvs.qtxdgTools,
    drvs.lxqtWaylandSession,
    drvs.lxqtGlobalkeys,
    drvs.libdbusmenuLxqt,
    drvs.lxqtMenuData,
    drvs.lxqtPanel,
    drvs.lxqtThemes,
    drvs.lxqtConfig,
    drvs.lxqtRunner,
    drvs.lxqtXdgDesktopPortal,
    drvs.lxqtNotificationd,
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
            (fun x => (x & { dest = "rootfs/", priority | priority 1 = (std.record.get_or "priority" 0 x) + 2 }))
            (
              _baseBaseRootfs.biDrvs
              # @ _cosmicPackages
              # @ _lxqtPackages
              @ [drvs.llvmLldb]
              # @ [drvs.labwc]
              # @ [drvs.kwin]
              # @ _plasmaPackages
              # @ [drvs.plasmaCommon]
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
      drvs.busyboxAarch64,
      # drvs.dashAarch64,
      # drvs.dashSh,
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
            "%,
      m%"cp /aarch64-unknown-linux-musl/boot/Image ${DEST}"%,
    ],
  }
}
