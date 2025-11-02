{
  lib,
  drvs,
  glib | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/glib/2.86/glib-2.86.1.tar.xz",
      sha256sum = "119d1708ca022556d6d2989ee90ad1b82bd9c0d1667e066944a6d0020e2d5e57",
    },
    biDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
    ],

    extraMesonArgs = ["-Dbsymbolic_functions=false", "-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false"],
    postInstallPhase = [
      m%"sed -i 's@-Wl,--whole-archive@-lgmodule-2.0@g' ${DEST}/usr/lib/pkgconfig/gmodule-2.0.pc"%,
      m%"sed -i 's@-Wl,--whole-archive@@g' ${DEST}/usr/lib/pkgconfig/gmodule-export-2.0.pc"%,
    ]
  },
  glibDebug =
    glib
    & {
      debug = true,
      extraMesonArgs | priority 1 = ["-Dbsymbolic_functions=false", "-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=enabled", "-Dtests=false"],
    }
}
& {
  lib,
  drvs,
  glib,
  glibNoExportDynamic =
    glib
    & {
      extraMesonArgs | priority 1 = [
        "-Dbsymbolic_functions=false",
        "-Dglib_assert=true",
        "-Dnls=disabled",
        "-Dglib_debug=disabled",
        "-Dtests=false"
      ],

      postInstallPhase | priority 1 = [
        m%"sed -i 's@-Wl,--whole-archive@-lgmodule-2.0@g' ${DEST}/usr/lib/pkgconfig/gmodule-2.0.pc"%,
        m%"sed -i 's@-Wl,--export-dynamic@@g' ${DEST}/usr/lib/pkgconfig/gmodule-2.0.pc"%,
        m%"sed -i 's@-Wl,--whole-archive@@g' ${DEST}/usr/lib/pkgconfig/gmodule-export-2.0.pc"%,
        m%"sed -i 's@-Wl,--export-dynamic@@g' ${DEST}/usr/lib/pkgconfig/gmodule-export-2.0.pc"%,
      ]
    }
}
& {
  lib,
  drvs,
  glib,
  glibDebug,
  glibNoDl =
    let _g =
      glibDebug
    in
    _g
    & {
      preConfigurePhase = [
        m%"sed -i 's|have_dlopen_dlsym = true|have_dlopen_dlsym = false|g' ${SRC}/meson.build"%
      ],
      extraMesonArgs | priority 2 = _g.extraMesonArgs @ ["-Dforce_posix_threads=true"]
    }
}
