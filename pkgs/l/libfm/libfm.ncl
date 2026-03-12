{
  lib,
  drvs,
  libfmExtra | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/lxde/libfm/archive/refs/tags/1.4.1.tar.gz",
      sha256sum = "1dff59162eb1ca5d1a6b945de4d0bdf2256a5264f54c9225b8599adce45dcb05",
    },
    extraConfigureFlags = [
      "--disable-old-actions",
      "--disable-udisks",
      "--disable-gtk-doc",
      "--without-gtk",
      "--with-extra-only",
    ],
    perlProvider = drvs.perlDynamic,

    biDrvs = [
      drvs.gettext,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.gtkDoc,
      drvs.intltool,
      drvs.perlXmlParserDynamic,
      drvs.muslShared,
    ]
  }
}
