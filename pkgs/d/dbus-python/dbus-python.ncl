{
  lib,
  dbus,
  glib,
  pcre2,
  libffi,
  zlibNg,

  dbusPython | lib.MesonPackage = {
    singleSource = {
      uri = "https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.3.2.tar.gz",
      sha256sum = "ad67819308618b5069537be237f8e68ca1c7fcc95ee4a121fe6845b1418248f8"
    },
    biDrvs =
      lib.biMap [
        dbus,
        glib,
        pcre2,
        libffi,
        zlibNg,
      ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lffi",
        "-l:libpython3.12.a",
      ]
    }
  }
}
