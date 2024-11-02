{
  lib,
  drvs,
  libnotify | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://gitlab.gnome.org/GNOME/libnotify/-/archive/0.8.3/libnotify-0.8.3.tar.gz",
        sha256sum = "5bcfeff21b6669c009c862e25c42556723f7a46c2c3454fce0fd532ebed715a0",
      },
      extraMesonArgs = [
        "-Dtests=false",
        "-Dintrospection=disabled",
        "-Dman=false",
        "-Dgtk_doc=false",
      ],
      biDrvs = [
        drvs.gdkPixbuf,
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg
      ],
      preConfigurePhase = [
        m%"find "${SRC}" -name "meson.build"|xargs sed -i 's/shared_library/library/g'"%
      ],
      postInstallPhase = [
        m%"sed -i 's@-Wl,--version-script,'"${SRC}"'/libnotify/libnotify.map@@g' ${DEST}/usr/lib/pkgconfig/libnotify.pc"%
      ],
    }
}
