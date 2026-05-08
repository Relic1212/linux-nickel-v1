{
  lib,
  drvs,
  tinysparql | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/tinysparql/-/archive/3.11.0/tinysparql-3.11.0.tar.bz2",
      sha256sum = "49bf23310b02e11b4880a12f7d62e4f3f5f561b23ab9b7da374bce486c893a1b",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      #   EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
      EXTRA_LDFLAGS = ["-lc++"],
    },
    extraMesonArgs = [
      "-Dintrospection=disabled",
      "-Dvapi=disabled",
      "-Dbuiltin_modules=true",
      "-Ddocs=false",
      "-Dman=false",
      "-Dtests=false",
      #   "-Dstemmer=disabled",
      "-Davahi=disabled",
      "-Dsystemd_user_services=false",
    ],
    preConfigurePhase = [
      m%"sed -i 's|shared_module|library|g' ${SRC}/src/http/meson.build"%,
      m%"sed -i 's|shared_module|library|g' ${SRC}/src/common/meson.build"%,
    ],
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
    ],
  }
}
