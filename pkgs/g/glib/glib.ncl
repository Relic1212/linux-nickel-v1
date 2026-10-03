{
  lib,
  drvs,
  glib | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/glib/2.90/glib-2.90.0.tar.xz",
      sha256sum = "17d15cac2af80a33271127408e0abc2748eb297c595c2a26409e81e14e7d1b8f",
    },
    options = {
      patched | default = false,
    },
    patches = (
      if options.patched then
        [
          {
            file = "musl-patches.patch",
            sha256sum = "cb621c792c8df955709f09c2247d2dd56439118795901ca99137004d507c56d7",
          },
        ]
      else
        []
    ),

    extraMesonArgs = ["-Dbsymbolic_functions=false", "-Dglib_assert=false", "-Dnls=disabled", "-Dglib_debug=disabled", "-Dtests=false"],
    postInstallPhase = [
      m%"sed -i 's@-Wl,--whole-archive@-lgmodule-2.0@g' ${DEST}/usr/lib/pkgconfig/gmodule-2.0.pc"%,
      m%"sed -i 's@-Wl,--whole-archive@@g' ${DEST}/usr/lib/pkgconfig/gmodule-export-2.0.pc"%,
    ],
    pDrvs = [
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
    ],
  },
  glibPatched =
    glib
    & {
      options.patched = true,
    },
  glibDebug =
    glibPatched
    & {
      debug = true,
      extraMesonArgs | priority 1 = [
        "-Dbsymbolic_functions=false",
        "-Dglib_assert=false",
        "-Dnls=disabled",
        "-Dglib_debug=enabled",
        "-Dtests=false"
      ],

      postInstallPhase | priority 1 = [],
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
  glibPatched,
  glibNoDl =
    let _g =
      glibPatched
    in
    _g
    & {
      preConfigurePhase = [
        m%"sed -i 's|have_dlopen_dlsym = true|have_dlopen_dlsym = false|g' ${SRC}/meson.build"%
      ],
      extraMesonArgs | priority 2 = _g.extraMesonArgs @ ["-Dforce_posix_threads=true"]
    }
}
