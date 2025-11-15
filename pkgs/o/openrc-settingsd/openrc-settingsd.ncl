{
  lib,
  drvs,
  openrcSettingsd | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.postmarketos.org/postmarketOS/openrc-settingsd/-/archive/v1.5.0/openrc-settingsd-v1.5.0.tar.bz2",
      sha256sum = "9558a10d26d4d5a3f4382930a4a8820e0b62310d186b7e45503b9a43280f7979"
    },

    extraMesonArgs = [
      "-Dopenrc=disabled",
      "-Denv-update=''",
    ],
    preConfigurePhase =
      std.array.map
        (fun s =>
          "sed -i 's|parse_boolean|openrc_settingsd__parse_boolean|g' ${SRC}%{s}"
        )
        [
          "/src/copypaste/util.h",
          "/src/copypaste/util.c",
          "/src/copypaste/hwclock.c",
        ],

    biDrvs = [
      drvs.acl,
      drvs.attr,
      drvs.dbus,
      drvs.duktape,
      drvs.elogindWithPolkit,
      drvs.eudev,
      drvs.expat,
      drvs.gettext,
      drvs.glib,
      drvs.gudev,
      drvs.inih,
      drvs.libcap,
      drvs.libdrm,
      drvs.libevdev,
      drvs.libffi,
      drvs.libinput,
      drvs.libpamFinal,
      drvs.libpciaccess,
      drvs.libxkbcommon,
      drvs.libxslt,
      drvs.linuxHeaders,
      drvs.mtdev,
      drvs.pcre2,
      drvs.zlibNg,
      drvs.polkit,
    ],
  }
}
