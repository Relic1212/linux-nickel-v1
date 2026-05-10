{
  lib,
  drvs,
  tinysparql | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/tinysparql/-/archive/3.11.0/tinysparql-3.11.0.tar.bz2",
      # sha256sum = "49bf23310b02e11b4880a12f7d62e4f3f5f561b23ab9b7da374bce486c893a1b",
      uri = "https://gitlab.gnome.org/GNOME/tinysparql/-/archive/3.8.1/tinysparql-3.8.1.tar.bz2",
      sha256sum = "d790f1f89436272319e1d121bcd9636a9be44c093d1be23e3c6780844c7bd4ea"
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      #   EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
      EXTRA_LDFLAGS = ["-lc++"],
    },
    debug = true,
    extraMesonArgs = [
      "-Dintrospection=disabled",
      "-Dvapi=disabled",
      # "-Dbuiltin_modules=true",
      "-Ddocs=false",
      "-Dman=false",
      "-Dtests=false",
      #   "-Dstemmer=disabled",
      "-Davahi=disabled",
      "-Dsystemd_user_services=false",
    ],
    preConfigurePhase = [
      # m%"sed -i 's|shared_module|library|g' ${SRC}/src/http/meson.build"%,
      # m%"sed -i 's|shared_module|library|g' ${SRC}/src/common/meson.build"%,
      ##
      m%"sed -i 's|shared_module|library|g' ${SRC}/src/libtracker-http/meson.build"%,
      m%"sed -i 's|shared_module|library|g' ${SRC}/src/libtracker-common/meson.build"%,
    ],
    postInstallPhase =
      let
        httpSymbols = [
          "initialize_types",
          "print_parameter_entry",
          "tracker_get_debug_flags",
          "tracker_http_client_get_type",
          "tracker_http_client_soup_get_type",
          "tracker_http_server_get_type",
          "tracker_http_server_soup_get_type",
        ],
        icuSymbols = [
          "tracker_collation_init",
          "tracker_collation_shutdown",
          "tracker_collation_utf8",
          "tracker_parser_casefold",
          "tracker_parser_free",
          "tracker_parser_new",
          "tracker_parser_next",
          "tracker_parser_normalize",
          "tracker_parser_reset",
          "tracker_parser_tolower",
          "tracker_parser_toupper",
          "tracker_parser_unaccent",
          "tracker_language_get_type",
          "tracker_language_new",
          "tracker_language_stem_word",
        ]
      in
      [
        "cd ${DEST}/usr/lib/tinysparql-3.0",
        "mv libtracker-parser-libicu.so libtracker-parser-libicu.a",
        "mv libtracker-http-soup3.so libtracker-http-soup3.a",
      ]
      @ (std.array.map (fun s => "objcopy --redefine-sym %{s}=tracker_parser_icu__%{s} libtracker-parser-libicu.a") icuSymbols)
      @ (std.array.map (fun s => "objcopy --redefine-sym %{s}=tracker_http_soup3__%{s} libtracker-http-soup3.a") httpSymbols),
    biDrvs = [
      drvs.snowball,
      drvs.glib,
      drvs.jsonGlib,
      drvs.libffi,
      drvs.libicu,
      drvs.libpsl,
      drvs.libsoup3,
      drvs.libxml2,
      drvs.nghttp2,
      drvs.pcre2,
      drvs.sqlite,
      drvs.zlibNg,
      drvs.dbus,
    ],
  }
}
