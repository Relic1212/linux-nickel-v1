{
  lib,
  drvs,
  gtkgreet | lib.MesonPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~kennylevinsen/gtkgreet/archive/ac3f9ec05ee2fdd116081869b808a429538816a5.tar.gz",
      sha256sum = "90b0f6df134c04ca8169c4d3a53e1aca66368379f2209736de2a6812c351d95e",
    },

    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.glibDynamic,
      drvs.muslShared,
      drvs.hwdata,
      drvs.gobjectDynamic,
      drvs.cairoGobject,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.libjpegTurbo,
      drvs.libepoxy,
      drvs.atSpi2Core,
      drvs.mesa2,
      drvs.libelf,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.llvmConfigStatic,
      drvs.spirvTools,
      drvs.spirvLlvmTranslator,
      drvs.gtk3,
      drvs.gtkLayerShell,
      drvs.jsonC,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libinput,
      drvs.libevdev,
      drvs.mtdev,
      drvs.eudev,
      drvs.xz,
      drvs.openssl,
      drvs.kmod,
      drvs.zstd,
    ],
    preConfigurePhase = [
      m%"sed -i 's@werror=true@werror=false@g' ${SRC}/meson.build"%
    ],
  },

  gtkgreetSwayConf | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/etc/greetd",
      m%"echo 'exec "gtkgreet -l; swaymsg exit"' > ${DEST}/etc/greetd/sway-conf"%,
      m%"echo "input type:keyboard xkb_layout se" >> ${DEST}/etc/greetd/sway-conf"%,
      m%"echo sway > ${DEST}/etc/greetd/environments"%,
      m%"echo niri >> ${DEST}/etc/greetd/environments"%,
      m%"
      echo '
      [terminal]
      # The VT to run the greeter on. Can be "next", "current" or a number
      # designating the VT.
      vt = 1

      # The default session, also known as the greeter.
      [default_session]

      # `agreety` is the bundled agetty/login-lookalike. You can replace `/bin/sh`
      # with whatever you want started, such as `sway`.
      command = "/usr/bin/sway -c /etc/greetd/sway-conf"

      # The user to run the command as. The privileges this user must have depends
      # on the greeter. A graphical greeter may for example require the user to be
      # in the `video` group.
      user = "greeter"
      ' > ${DEST}/etc/greetd/config.toml
      "%
    ]
  }
}
