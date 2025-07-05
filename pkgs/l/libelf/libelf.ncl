{
  lib,
  drvs,

  libelf | lib.AutotoolsPackage = {
    name = "libelf",
    singleSource = {
      uri = "https://sourceware.org/elfutils/ftp/0.191/elfutils-0.191.tar.bz2",
      sha256sum = "df76db71366d1d708365fc7a6c60ca48398f14367eb2b8954efc8897147ad871"
    },
    biDrvs = [
      drvs.argpStandalone,
      drvs.muslFts,
      drvs.muslObstack,
      drvs.zlibNg,
      drvs.m4,
    ],
    preConfigurePhase = [
      "cd ${SRC}",
      m%"sed -i  's@dso_LDFLAGS="-shared"@dso_LDFLAGS=""@g' configure"%,
    ],
    extraConfigureFlags = [
      "--disable-demangler",
      "--disable-nls",
      "--enable-libdebuginfod=dummy",
      "--disable-debugpred",
      "--disable-debuginfod",
      "--without-lzma",
      "--without-zstd",
    ],
    buildPhase = [
      m%"printf '%s\n' "all:" "install:" > src/Makefile"%,
      "make -C libelf libelf.a",
      "make -C config libelf.pc",
      "make -C libasm libasm.a",
      "make -C libdwfl libdwfl.a",
      "make -C libdwelf libdwelf.a",
      "make -C libebl libebl.a",
      "make -C backends libebl_backends.a",
      "make -C libcpu libcpu.a",
      "make -C libdw libdw.a",
      "make -C config libdw.pc",
    ],
    installPhase = [
      "export DESTDIR=${DEST}",
      "make -C libelf install-pkgincludeHEADERS",
      "make -C libelf install-includeHEADERS",
      "make -C libdw install-pkgincludeHEADERS",
      "make -C libdw install-includeHEADERS",
      "make -C libasm install-pkgincludeHEADERS",
      "make -C libdwfl install-pkgincludeHEADERS",
      "make -C libdwelf install-pkgincludeHEADERS",
      "install -d -m0755  ${DEST}/usr/lib/pkgconfig/",
      "install -m0755 libcpu/libcpu.a  ${DEST}/usr/lib/",
      "install -m0755 libdw/libdw.a    ${DEST}/usr/lib/",
      "install -m0755 libelf/libelf.a   ${DEST}/usr/lib/",
      "install -m0755 backends/libebl_backends.a    ${DEST}/usr/lib/",
      "install -m0755 libdwfl/libdwfl.a     ${DEST}/usr/lib/",
      "install -m0755 libdwelf/libdwelf.a   ${DEST}/usr/lib/",
      "install -m0755 libasm/libasm.a   ${DEST}/usr/lib/",
      "install -m0755 libebl/libebl.a   ${DEST}/usr/lib/",
      "install -m0755 config/libdw.pc  ${DEST}/usr/lib/pkgconfig/",
      "install -m0755 config/libelf.pc  ${DEST}/usr/lib/pkgconfig/",

      # rm -f ${DEST}/usr/lib/lib*.so*
      m%"sed -i 's@-lelf@-lelf -lz@g' ${DEST}/usr/lib/pkgconfig/libelf.pc"%,
    ]
  }
}
