{
  lib,
  linuxHeaders,

  libcap | lib.MakePackage = {
    name = "libcap",
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-2.70.tar.gz",
      sha256sum = "18f00ea97c7541af86379dec9d4d8ea838aac4a1f70177d81d91657e4e43b808",
    },
    separateBuildDir = false,
    preConfigurePhase = [
      # "cd ${SRC}",
      "sed -i 's@/bin/bash@/bin/sh@g' progs/mkcapshdoc.sh",
      "echo \"all: \n\techo 1\n\" > doc/Makefile",
      "echo \"\ninstall: \n\techo 1\n\" >> doc/Makefile",
      "sed -i 's@gcc@clang@g' Make.Rules",
    ],
    extraMakeArgs = [
      "CC=\"clang -static --static\"",
      "GCC=\"clang -static --static\"",
      "LD=\"clang -static --static\"",
      "sbindir=/usr/bin",
      "sbin=/usr/bin",
      "exec_prefix=/usr",
      "prefix=/usr",
      "lib=/usr/lib",
      "LIBDIR=/usr/lib",
      "BINDIR=/usr/bin",
      "SBINDIR=/usr/bin",
      "DYNAMIC=no",
      "LIBCSTATIC=yes",
      "SHARED=no",
    ],

    extraMakeInstallArgs = extraMakeArgs,

    biDrvs =
      lib.biMap [
        linuxHeaders,
      ]
  }
}
