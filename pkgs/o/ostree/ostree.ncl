{
  lib,
  drvs,
  ostree
    | lib.
    # AutotoolsPackage 
    AutomakePackage
    = {
      singleSource = {
        # uri = "https://github.com/ostreedev/ostree/releases/download/v2024.8/libostree-2024.8.tar.xz",
        # sha256sum = "e2136e116669f114ff7349f12e299f63c0bece733451649414a8dcd85b863c3f",
        # uri = "https://github.com/ostreedev/ostree/releases/download/v2026.4/libostree-2026.4.tar.xz",
        # sha256sum = "b26c9016eb03bb4ee52cc00c642d56e00fc79ae7faac6bf4aa317d7451339ef7",

        uri = "https://github.com/ostreedev/ostree/archive/refs/tags/v2026.4.tar.gz",
        sha256sum = "b9b64be64901e699081b8cbe54538c8c037936d7b2a789021769cdbb8fa689ef",
      },

      sourceInputs = [
        { src = singleSource },
        {
          src = {
            uri = "https://github.com/GNOME/libglnx/archive/b415d046880d585e5161bf230590543adeea4fe6.tar.gz",
            sha256sum = "f4ca1b2dcc5e7902dac3b11e381e75d2fa47aa40a73fb3de201a7cc6f718798d"
          },
          dest = "libglnx",
        },
        {
          src = {
            uri = "https://github.com/mendsley/bsdiff/archive/b817e9491cf7b8699c8462ef9e2657ca4ccd7667.tar.gz",
            sha256sum = "7bf052085968119a1ef6d9dedf80e0b01669f2f383e6179f510f851af2cc6e94",
          },
          dest = "bsdiff"
        }
      ],
      autoReconf = "(cd ${SRC} && NOCONFIGURE=1 ./autogen.sh)",
      preConfigurePhase = [
        # m%"sed -i "s@#include <err.h>@#include <stdint.h>\n#include <err.h>@g" ${SRC}/src/libostree/ostree-sysroot-deploy.c"%,
        m%"sed -i "s@#include <string.h>@#include <string.h>\n#include <stdint.h>@g" ${SRC}/src/libostree/ostree-bootloader-aboot.c"%,
      ],

      biDrvs = [
        drvs.bison,
        # drvs.pkgconf,
        drvs.pythonFull,
        # drvs.m4,
        drvs.linuxHeaders,
      ],
      pDrvs = [
        drvs.gpgme,
        drvs.zstd,
        drvs.lz4,
        drvs.xz,
        drvs.e2fsprogs,
        drvs.curl,
        drvs.libsoup,
        drvs.fuse,
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
  drvs,
  sqlite | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.sqlite.org/2024/sqlite-autoconf-3470200.tar.gz",
      sha256sum = "f1b2ee412c28d7472bc95ba996368d6f0cdcf00362affdadb27ed286c179540b"
    }
  }
}
