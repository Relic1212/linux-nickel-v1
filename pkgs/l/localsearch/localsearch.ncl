{
  lib,
  drvs,
  localsearch | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/localsearch/-/archive/3.11.1/localsearch-3.11.1.tar.bz2",
      # sha256sum = "15ace996213f2e0b7dd2bb8bb21de9fedb6a30b2de99a92035488efef8f0da18",

      uri = "https://gitlab.gnome.org/GNOME/localsearch/-/archive/3.8.1/localsearch-3.8.1.tar.bz2",
      sha256sum = "13466227841d355d7166a7e929b3a5f1f40a2364befa583088d17440c4cf44c9",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      #   EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
      EXTRA_LDFLAGS = ["-lc++"],
    },
    extraMesonArgs = [
      "-Dman=false",
      "-Dbattery_detection=none",
      "-Dgeneric_media_extractor=none",
      "-Dsystemd_user_services=false",
    ],
    preConfigurePhase = [
      m%"sed -i "s|'gobject-introspection-1.0'|'gobject-introspection-1.0',required:false|g" ${SRC}/meson.build"%,
      m%"sed -i "s|script_conf.set('typelibdir', typelib_dir)|script_conf.set('typelibdir', '')|g" ${SRC}//src/tracker/meson.build"%,
      "for f in $(find ${SRC} -name meson.build);do sed -i 's|shared_module|library|g' ${f};done",
      "for f in $(find ${SRC} -name '*.c');do sed -i 's|tracker_file_get_size|localsearch__tracker_file_get_size|g' ${f};done",
      "for f in $(find ${SRC} -name '*.h');do sed -i 's|tracker_file_get_size|localsearch__tracker_file_get_size|g' ${f};done",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libseccomp,
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
      drvs.tinysparql,
      drvs.gudev,
      drvs.libxslt,
      drvs.eudev,
    ],
  }
}
