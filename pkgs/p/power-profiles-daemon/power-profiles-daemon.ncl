{
  lib,
  drvs,
  powerProfilesDaemon | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/upower/power-profiles-daemon/-/archive/0.30/power-profiles-daemon-0.30.tar.gz",
      sha256sum = "90f2c95024861d9f4062abedd514084939224e7a49edd468f001af7260ec8e6c"
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.gudev,
      drvs.eudev,
      drvs.linuxHeaders,
      drvs.upower,
      drvs.polkit,
      drvs.elogindWithPolkit,
      drvs.libcap,
    ],
    extraMesonArgs = [
      "-Dsystemdsystemunitdir=\"\"",
      "-Dtests=false",
    ],
    preConfigurePhase = [
      "sed -i 's|shared_library|library|g' ${SRC}/src/meson.build",
      m%"sed -i 's|\/bin\/false|\/usr/libexec/power-profiles-daemon|g' ${SRC}/data/power-profiles-daemon.dbus.service.in"%,
    ],
    postInstallPhase = [
      # "rm -r ${DEST}/usr/no",
      #   "install -d -m0755 ${DEST}/etc/dinit.d/",

      #   m%"
      #   echo '
      #   type = process 
      #   command = /usr/libexec/power-profiles-daemon -v 
      #   depends-on = dbusd
      #   depends-on = upowerd
      #   logfile = /var/log/power-profiles-daemon.log
      #   ' > ${DEST}/etc/dinit.d/power-profiles-daemon
      #   "%,
    ]
  }
}
