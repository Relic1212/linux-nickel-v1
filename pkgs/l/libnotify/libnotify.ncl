{
  lib,
  drvs,
  libnotify | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/libnotify/-/archive/0.8.9/libnotify-0.8.9.tar.bz2",
      sha256sum = "1acd685c4340cf350e126b740c1307c5b0551e5b2f9be9bde4424390bb8a3d5c",
    },
    extraMesonArgs = [
      "-Dtests=false",
      "-Dintrospection=disabled",
      "-Dman=true",
      "-Dgtk_doc=false",
    ],
    biDrvs = [
      drvs.libxslt,
      drvs.docbookXml,
      drvs.docbookXslNons,
    ],
    pDrvs = [
      drvs.gdkPixbufFull,
    ],
    preConfigurePhase = [
      m%"find "${SRC}" -name "meson.build"|xargs sed -i 's/shared_library/library/g'"%,
      m%"sed -i 's@http://docbook.sourceforge.net/release/xsl-ns/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${SRC}/meson.build"%,
    ],
    postInstallPhase = [
      m%"sed -i 's@-Wl,--version-script,'"${SRC}"'/libnotify/libnotify.map@@g' ${DEST}/usr/lib/pkgconfig/libnotify.pc"%
    ],
  }
}
