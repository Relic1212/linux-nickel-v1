{
  lib,
  drvs,
  netcatOpenbsd | lib.MakePackage = {
    singleSource = {
      uri = "https://salsa.debian.org/debian/netcat-openbsd/-/archive/debian/1.234-1/netcat-openbsd-debian-1.234-1.tar.bz2",
      sha256sum = "32165da4e8ce72a15f99a5e971bf3a844d84bc3741c1c8c5c83e7b39466cb89c",
    },
    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/3a368567d8f1bcf4935151dfaf5759453c67d1e6/main/netcat-openbsd/base64.c",
          sha256sum = "9dc47d8e013881d3372319c209dcbaa3a09dbaf440fbfa503b554ce2998b5fa6"
        }
      }
    ],
    buildEnv = {
      LD = null,
    },
    extraMakeArgs = [
      "LDFLAGS=\"${LDFLAGS}\"",
    ],
    preConfigurePhase =
      [
        # "touch ${SRC}/bsd.prog.mk",
        "for p in $(cat ./debian/patches/series); do patch -p1 < ./debian/patches/$p; done",
        m%"sed -i 's@`$(PKG_CONFIG) --libs libbsd`@-lbsd -lmd@' ${SRC}/Makefile"%,
        m%"sed -i 's@socks.c@socks.c base64.c@' ${SRC}/Makefile"%,
      ]
      @ (
        # https://github.com/aperezdc/signify/pull/43
        let decl = [
          "int b64_pton(char const *, unsigned char *, size_t);",
          "int b64_ntop(unsigned char const *, size_t , char *, size_t);",
        ]
        in
        let sleft = std.string.join "\\n" decl in
        [
          m%"sed -i "s@include \"atomicio.h\"@include \"atomicio.h\"\\n%{sleft}@g" ${SRC}/socks.c"%
        ]
      ),

    installPhase = [
      "install -Dm0755 nc ${DEST}/usr/bin/nc",
      "install -Dm0755 nc.1 ${DEST}/usr/share/man/man1/nc.1",
    ],

    biDrvs = [
      drvs.linuxHeaders,
      drvs.libbsd,
      drvs.libmd,
      drvs.pkgconfMeson,
    ]
  }
}
