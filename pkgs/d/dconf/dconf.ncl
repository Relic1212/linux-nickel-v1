{
  lib,
  drvs,
  dconf | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/dconf/0.49/dconf-0.49.0.tar.xz",
      sha256sum = "16a47e49a58156dbb96578e1708325299e4c19eea9be128d5bd12fd0963d6c36"
    },
    extraMesonArgs = [
      "-Dbash_completion=false",
      "-Dvapi=false",
      "-Dman=false",
      "-Dsystemduserunitdir=no",
    ],
    preConfigurePhase = [
      "sed -i 's|shared_library|library|g' ${SRC}/gsettings/meson.build",
      "sed -i 's|shared_library|library|g' ${SRC}/client/meson.build",
    ],
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glibPatched,
      drvs.dbus,
      drvs.expat,
      drvs.linuxHeaders,
    ]
  }
}
