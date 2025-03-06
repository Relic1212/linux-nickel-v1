{
  lib,
  drvs,
  flatpak | lib.MesonPackage
    = {
      singleSource = {
        # uri = "https://github.com/flatpak/flatpak/archive/refs/heads/main.zip",

        # sha256sum = "efa3b11337588af274ed6d22b9b0c681e857782f1c7bc6d4e1ef0e6a9bd54aff",
        uri = "https://github.com/flatpak/flatpak/archive/fa252b865a9305a5ff01564140a7273f05503ece.zip",
        sha256sum = "da812757a8e9aa7173603bffc349157709298f7fc8dbe225f1a0050f4950ecd0"


      },
      sourceInputs = [
        {
          src = singleSource
        },
        {
          src = {
            uri = "https://github.com/pyparsing/pyparsing/archive/refs/tags/3.2.0.tar.gz",
            sha256sum = "91f52e4e06a2ee736531a3038fc2c7d6bb83f321831435fcedc14f95749c86ac"
          },
          dest = "pyparsing"
        }
      ],
      biDrvs = [
        drvs.glib,
        drvs.curl,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.bison,
        drvs.libcap,
        drvs.libarchive,
        drvs.openssl,
        drvs.libpsl,
        drvs.libxml2,
        drvs.fuse,
        drvs.ostree,
        drvs.jsonGlib,
        drvs.libyaml,
        drvs.appstream,
        drvs.libxmlb,
        drvs.gdkPixbufFull,
        drvs.libpng,
        drvs.libjpegTurbo,
        drvs.libassuan,
        drvs.libgpgError,
        drvs.gpgme,
        drvs.zstd,
        drvs.xz,
        drvs.lz4,
        drvs.bubblewrap,
        drvs.xdgDbusProxy,
        drvs.m4,
        drvs.linuxHeaders,

        # drvs.itstool,
      ],
      preConfigurePhase = [
        # https://github.com/kiss-community/community/blob/153bd6c63fb8291b385e95d30da1dc6b9de87244/community/flatpak/build#L14
        m%"PYTHONPATH=${SRC}/pyparsing:$(python -c "import sys; print(':'.join(sys.path))")"%,
        "export PYTHONPATH",
      ],
      extraMesonArgs = [
        "-Dseccomp=disabled",
        "-Dsystem_helper=disabled",
        "-Dtests=false",
        "-Dxauth=disabled",
        "-Dsystem_bubblewrap=/usr/bin/bwrap",
        "-Dsystem_dbus_proxy=/usr/bin/xdg-dbus-proxy",
      ],

      buildEnv = {
        EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
        EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
        EXTRA_LDFLAGS = [
          "-llzma",
          "-lcurl",
          "-l:libjson-glib-1.0.a",
          "-l:libostree-1.a",
          "-l:libarchive.a",
          "-l:libxml2.a",
          "-lzstd",
          "-lssl",
          "-lcrypto",
          "-l:libgpgmepp.a",
          "-l:libgpgme.a",
          "-llz4",
          "-l:libassuan.a",
          "-l:libgpg-error.a",
          "-lpsl",
        ],
      },
    }
}
& {
  lib,
  drvs,
  pythonPyparsing | lib.SetuptoolPackage
    = {
      singleSource = {
        uri = "https://github.com/pyparsing/pyparsing/archive/refs/tags/3.2.0.tar.gz",
        sha256sum = "91f52e4e06a2ee736531a3038fc2c7d6bb83f321831435fcedc14f95749c86ac"
      }
    }
}
