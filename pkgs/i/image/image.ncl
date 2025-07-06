(import "rootfs.ncl")
& {
  lib,
  baseBaseRootfs,
  erofsUtils,
  mtools,
  genimage,
  cryptsetup,
  systemdBoot,
  llvm,
  pythonFull,
  utilLinux,
  linuxFirmware,
  uutils,

  uutilsSymlinks,

  sbase,
  libarchive,
  wget,
  bzip2,

  vim,
  bc,
  dash,
  dashSh,
  iproute2,

  kbd,

  pigz,
  curl,
  metalog,
  #zsh,
  fish,
  mawk,
  ncurses,
  basefiles,
  dinit,
  dinitServicesV3,
  dinitUtils,
  shadow,
  libcap,
  utilLinux,
  pciutils,
  xz,
  #linux,
  v4l2loopback,

  eudev,
  dbus,
  bkeymaps,
  kmod,
  keyutils,
  mandoc,
  less,
  jq,
  earlyoom,
  # net
  dhcpcd,
  iwd,
  dropbear,
  openresolv,
  caCertificates,

  # enc
  e2fsprogs,
  fscryptUnlockHome,
  openssl,
  fscrypt,

  # gui
  seatd,
  libinput,
  libxkbcommon,
  libx11,
  libdrm,
  xkeyboardConfig,
  xdgRuntimeRun,
  foot,
  fontconfig,
  ttfCroscore,
  dejavuFonts,
  hicolorIconTheme,
  terminusFont,
  # swayX11,
  swayfx,
  mwc,
  xwayland,
  xkbcomp,
  hyprland,
  hyprpaper,

  sway,

  rwaybar,
  brightnessctl,
  mako,
  basu,
  libnotify,
  strace,
  #dwl,
  psmisc,
  #uutilsProcps,
  #uutilsProcpsSymlinks,
  procps,
  wob,
  wmenu,
  dmenuWayland,
  sov,
  swayidle,
  swaylock,
  swaybg,
  wlClipboard,
  slurp,
  grim,
  grimshot,
  wfRecorder,
  j4MenuDesktop,
  lavalauncher,
  waybar,
  gammastep,
  gebaarLibinput,
  upower,
  acpid,
  laptopModeTools,
  #tuned,
  opendoas,
  rsync,
  file,
  ripgrep,
  # alsa
  alsaFirmware,
  alsaLibs,
  alsaUtils,
  # bt
  bluez,
  #blueAlsa,
  #bluez4,
  # pulseaudio14,
  # flatpak
  xdgDbusProxy,
  mountOthers,
  sbctl,
  pythonFull,
  autotiling,
  i3ipcPython,
  tzdata,
  sndiod,
  desktopFileUtils,
  squeekboard,
  lisgd,
  glib,
  gsettingsDesktopSchemas,
  gnomeDesktop,
  atSpi2Core,

  # hyprlandQtSupport,
  # hyprlandQtutils,

  # ttyescape
  buffybox,
  hkdm,
  ttyescape,
  wld,
  swc,
  velox,
  stWayland,

  flatpak,
  gnupg2,
  gpgme,
  bubblewrap,
  podman,
  conmon,
  crun,
  netavark,

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
        full = true,
        hasX11 = true,
        haveContainers = true,
        isVm = false,
      },
      name = "base-base-rootfs",
      biDrvs =
        lib.biMap (
          (
            if options.isVm then
              []
            else
              [
                linuxFirmware,
              ]
          )
          @ [
            # base
            # busyboxFinal,

            ## begin bsdutils
            # bsdutils,
            ## end bsdutils

            ## begin uutils
            uutils,
            uutilsSymlinks,
            #gnused,
            #gnugrep,
            (sbase & { priority = -1 }),
            libarchive,
            wget,
            bzip2,
            ## end uutils

            ## begin sbase
            #sbase,
            #(emptyStty & { priority = 10 }),
            #(ubase & { priority = -1 }),
            ## end sbase
            # vis,
            vim,
            bc,
            dash,
            dashSh,
            iproute2,
            (kbd & { priority = -1 }),
            pigz,
            curl,
            metalog,
            #zsh,
            fish,
            mawk,
            ncurses,
            basefiles,
            dinit,
            dinitServicesV3,
            dinitUtils,
            shadow,
            libcap,
            utilLinux,
            pciutils,
            xz,
            #linux,
            v4l2loopback,

            # linuxFirmwareSmaller,
            eudev,
            # mdevd,
            # mdevdConf,
            dbus,
            bkeymaps,
            kmod,
            keyutils,
            mandoc,
            less,
            # checkFirmware,
            jq,
            earlyoom,
            # net
            dhcpcd,
            iwd,
            dropbear,
            openresolv,
            caCertificates,

            # enc
            e2fsprogs,
            fscryptUnlockHome,
            openssl,
            fscrypt,

            # gui
            seatd,
            #sway,
            libinput,
            libxkbcommon,
            libx11,
            libdrm,
            xkeyboardConfig,
            xdgRuntimeRun,
            foot,
            fontconfig,
            ttfCroscore,
            # fontAwesome,
            dejavuFonts,
            hicolorIconTheme,
            terminusFont,
          ]
          @ (
            if options.hasX11 then
              [
                # swayX11,
                swayfx,
                mwc,
                xwayland,
                xkbcomp,
                hyprland,
                hyprpaper,
              ]
            else
              [
                sway,
              ]
          )
          @ (
            (
              if options.full then
                [
                  #cagebreak,
                  rwaybar,
                  brightnessctl,
                  mako,
                  basu,
                  libnotify,
                  strace,
                  #dwl,
                  psmisc,
                  #uutilsProcps,
                  #uutilsProcpsSymlinks,
                  procps,
                  wob,
                  wmenu,
                  dmenuWayland,
                  sov,
                  swayidle,
                  swaylock,
                  swaybg,
                  wlClipboard,
                  slurp,
                  grim,
                  grimshot,
                  wfRecorder,
                  j4MenuDesktop,
                  lavalauncher,
                  waybar,
                  gammastep,
                  gebaarLibinput,
                  upower,
                  acpid,
                  laptopModeTools,
                  #tuned,
                  opendoas,
                  rsync,
                  file,
                  ripgrep,
                  # alsa
                  (alsaFirmware & { priority = -1 }),
                  alsaLibs,
                  alsaUtils,
                  # bt
                  bluez,
                  #blueAlsa,
                  #bluez4,
                  # pulseaudio14,
                  # flatpak
                  xdgDbusProxy,
                  mountOthers,
                  sbctl,
                  pythonFull,
                  autotiling,
                  i3ipcPython,
                  tzdata,
                  sndiod,
                  desktopFileUtils,
                  squeekboard,
                  lisgd,
                  glib,
                  gsettingsDesktopSchemas,
                  gnomeDesktop,
                  atSpi2Core,

                  # hyprlandQtSupport,
                  # hyprlandQtutils,

                  # ttyescape
                  buffybox,
                  hkdm,
                  ttyescape,
                  wld,
                  swc,
                  velox,
                  stWayland,
                ]
              else
                []
            )
            @ (
              if options.haveContainers then
                [
                  flatpak,
                  gnupg2,
                  gpgme,
                  bubblewrap,
                  podman,
                  conmon,
                  crun,
                  netavark,
                ]
              else
                []
            )
          )
        )
    }
  ),
  baseImage =
    _rootfs2
    & {
      enableCcache = false,
      name = "base-image",
      biDrvs =
        lib.biMap [
          baseBaseRootfs,
          erofsUtils,
          mtools,
          genimage,
          cryptsetup,
          systemdBoot,
          llvm, # objdump
          pythonFull,
          utilLinux,
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

  dashAarch64,
  dashSh,
  linuxAarch64,
  basefiles,
  erofsUtils,
  basefilesAarch64,

  aarch64Image | lib.Package = {
    biDrvs =
      lib.biMap [
        # busyboxAarch64,
        dashAarch64,
        dashSh,
        linuxAarch64,
        basefiles,
        erofsUtils,
        basefilesAarch64,
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
