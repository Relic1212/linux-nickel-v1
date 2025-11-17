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
      singleSource,
      # sourceInputs = [
      #   {
      #     src = singleSource 
      #   },
      #   {
      #     src = {
      #       uri = "https://raw.githubusercontent.com/nixos/nixpkgs/refs/heads/master/pkgs/by-name/gl/glib/quark_init_on_demand.patch",
      #       sha256sum = "2b3e68e7aa9f2bab36eb5e144e98c438519057ea54e4abadccafff66e70f8539"
      #     }
      #   },
      #   {
      #     src = {
      #       uri ="https://raw.githubusercontent.com/nixos/nixpkgs/refs/heads/master/pkgs/by-name/gl/glib/gobject_init_on_demand.patch",
      #       sha256sum = "2e7296ce6f3c85056912df765dd137ed1f862d5cfbf12778b73b694ed297ba25"
      #     }
      #   },
      # ],
      patches = [
        # {
        #   file = "2757.patch",
        #   sha256sum = "2e1387874232b99816165fdfd8a70933b4c9356a870f3045104c68438c4844af"
        # },
        # {
        #   file = "2757-comment.patch",
        #   sha256sum = "8cb0c561c50870454f12a07fefa8d186d7164b48ddf5ae03760d94d359588c78"
        # },
        {
          file = "musl-patches.patch",
          sha256sum = "cb621c792c8df955709f09c2247d2dd56439118795901ca99137004d507c56d7",
        },
      ],
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
