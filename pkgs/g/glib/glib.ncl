{
  lib,
  pkgs,
  drvs,
  glib | lib.MesonPackage
    = {
      name = "glib",
      singleSource = {
        uri = "https://download.gnome.org/sources/glib/2.82/glib-2.82.1.tar.xz",
        sha256sum = "478634440bf52ee4ec4428d558787398c0be6b043c521beb308334b3db4489a6",
      },
      biDrvs = [drvs.pcre2, drvs.libffi, drvs.zlibNg],

      extraMesonArgs = ["-Dbsymbolic_functions=false", "-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false"],
      postInstallPhase = [
        m%"sed -i 's@-Wl,--whole-archive@-lgmodule-2.0@g' ${DEST}/usr/lib/pkgconfig/gmodule-2.0.pc"%,
        m%"sed -i 's@-Wl,--whole-archive@@g' ${DEST}/usr/lib/pkgconfig/gmodule-export-2.0.pc"%,
      ]
    },
}
