{
  lib,
  drvs,

  libsoup | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.3.tar.xz",
      sha256sum = "e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13"
    },
    pDrvs = [
      drvs.libpsl,
      drvs.glib,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg,
      drvs.libxml2,
      drvs.sqlite,
    ],
    extraMesonArgs = [
      "-Dtests=false",
      "-Dintrospection=disabled",
      "-Dgnome=false",
      "-Dtls_check=false",
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },
  }
}
& {
  lib,
  drvs,

  libsoup3 | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.5.tar.xz",
      sha256sum = "6891765aac3e949017945c3eaebd8cc8216df772456dc9f460976fbdb7ada234"
    },
    pDrvs = [
      drvs.libpsl,
      drvs.glib,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg,
      drvs.libxml2,
      drvs.sqlite,
      drvs.nghttp2,
    ],
    extraMesonArgs = [
      "-Dtests=false",
      "-Dintrospection=disabled",
      "-Dntlm=disabled",
      "-Dgssapi=disabled",
      "-Dtls_check=false",
      "-Dbrotli=disabled",
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
    },

    preConfigurePhase = [
      m%"sed -i "s|subdir\('examples'\)||g" ${SRC}/meson.build"%
    ]
  }
}
& {
  lib,
  drvs,
  nghttp2 | lib.AutomakePackage = {
    # generator ="Ninja",
    singleSource = {
      uri = "https://github.com/nghttp2/nghttp2/archive/refs/tags/v1.67.0.tar.gz",
      sha256sum = "e750161896a4b575f203ae378b199ddc9ec6ce6c06c7308d6a9b0290491cfca3"
    }
  }
}
