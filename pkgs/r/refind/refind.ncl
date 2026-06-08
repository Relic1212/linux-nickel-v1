{
  lib,
  drvs,
  refind | lib.MakePackage = {
    singleSource = {
      # uri = "https://sourceforge.net/projects/refind/files/0.14.2/refind-src-0.14.2.tar.gz",
      # sha256sum = "f7d93ce80da76b86c567281ea225b6a87907ce86ff77233c9357a522c115c8f0",

      uri = "https://sourceforge.net/projects/refind/files/0.14.1/refind-src-0.14.1.tar.gz",
      sha256sum = "474425d4dab2e4c2f6a7059e53c8919996793674a080e4fb97a712216333f123"
    },
    buildEnv = {
      # EXTRA_LDFLAGS = [
      #   "-lc",
      # ],
      EXTRA_CPPFLAGS = ["-fno-builtin"],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
    },

    extraMakeArgs = [
      "SHELL=/bin/sh",
      "CC=clang",
      "LD=ld.lld",
      "OPTIMFLAGS=\"-O2\"",
      "OBJCOPY=objcopy.binutils",
    ],
    extraMakeInstallArgs = extraMakeArgs,
    preConfigurePhase = [
      # "sed -i 's|-D_FILE_OFFSET_BITS=64|-D_FILE_OFFSET_BITS=64 -fno-builtin|g' ${SRC}/"
      # "sed -i 's|LOCAL_GNUEFI_CFLAGS  =|LOCAL_GNUEFI_CFLAGS  = -fno-builtin|g' ${SRC}/libeg/Makefile",
      "sed -i 's|-mno-red-zone|-mno-red-zone -fno-builtin|g' ${SRC}/Make.common",
      # "sed -i 's@bin/bash@bin/sh@g' ${SRC}/refind-install",
      m%"sed -i "s@bin\/bash@usr\/bin\/bash@g" ${SRC}/refind-install"%,
    ],
    biDrvs = [
      drvs.gnuEfi,
      drvs.binutilsObjcopy,
      drvs.bash,
    ]
  }
}
