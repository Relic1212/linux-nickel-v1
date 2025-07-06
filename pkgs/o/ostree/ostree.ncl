{
  lib,
  bison,
  glib,
  pkgconf,
  pcre2,
  zlibNg,
  libffi,
  libarchive,
  xz,
  e2fsprogs,
  fuse,
  pythonFull,
  m4,
  linuxHeaders,
  zstd,
  lz4,
  gpgme,
  libgpgError,
  libassuan,
  openssl,
  curl,
  libpsl,
  sqlite,
  libsoup,
  libxml2,

  ostree | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/ostreedev/ostree/releases/download/v2024.8/libostree-2024.8.tar.xz",
      sha256sum = "e2136e116669f114ff7349f12e299f63c0bece733451649414a8dcd85b863c3f",
    },

    biDrvs =
      lib.biMap [
        bison,
        glib,
        pkgconf,
        pcre2,
        zlibNg,
        libffi,
        libarchive,
        xz,
        e2fsprogs,
        fuse,
        pythonFull,
        m4,
        linuxHeaders,
        zstd,
        lz4,
        gpgme,
        libgpgError,
        libassuan,
        openssl,
        curl,
        libpsl,
        sqlite,
        libsoup,
        libxml2,
      ],
    extraConfigureFlags = [
      "--without-avahi",
      "--disable-glibtest",
      "--without-libsystemd",
      "--without-libmount",
      "--with-gpgme",
      # "--without-soup",
      "--enable-http2",
      "--without-composefs",
      "--with-openssl",
      "--with-curl",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lzstd",
        "-llz4",
      ],
    },
  }
}
& {
  lib,
  libpsl,
  glib,
  pcre2,
  libffi,
  zlibNg,
  libxml2,
  sqlite,

  libsoup | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.3.tar.xz",
      sha256sum = "e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13"
    },
    biDrvs =
      lib.biMap [
        libpsl,
        glib,
        pcre2,
        libffi,
        zlibNg,
        libxml2,
        sqlite,
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

  sqlite | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.sqlite.org/2024/sqlite-autoconf-3470200.tar.gz",
      sha256sum = "f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b"
    }
  }
}
