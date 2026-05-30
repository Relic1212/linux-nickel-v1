{
  lib,
  drvs,
  gnuEfi | lib.MakePackage = {
    singleSource = {
      #   uri = "https://github.com/ncroxon/gnu-efi/archive/refs/tags/4.0.4.tar.gz",
      #   sha256sum = "40b61e842a4efcbf80f3e53b2f220c044e8cfe46eb4dd6396c83b751240b1c0d",

      #   uri = "https://github.com/ncroxon/gnu-efi/archive/refs/tags/4.0.2.tar.gz",
      #   sha256sum = "f31488c3fc7d64257ec8fcad470ec75a936a4db77350fabaf043c52a7acbae72",

      uri = "https://github.com/ncroxon/gnu-efi/archive/refs/tags/3.0.19.tar.gz",
      sha256sum = "e2ae35d4bdab887aeb4fd2ee721aa8c3d39bbc50518c83800affa49b98dd9ce8",
    },

    preConfigurePhase = [
      # https://github.com/ncroxon/gnu-efi/commit/edfda7c396134c7109444b230ce4b0da1e61d524
      m%"sed -i 's|typedef wchar_t CHAR16|typedef uint16_t CHAR16|g' ${SRC}/inc/x86_64/efibind.h"%,
      # https://github.com/ncroxon/gnu-efi/pull/5/changes
      "sed -i 's|z nocombreloc|z nocombreloc -z norelro|g' ${SRC}/Make.defaults",
    ],

    buildEnv = {
      LDFLAGS = [],
      "OBJCOPY" = "objcopy.binutils",
    },
    extraMakeArgs = [
      "CC=clang",
      "HOSTCC=clang",
      "LD=ld.lld",
      "OBJCOPY=objcopy.binutils",
      # "LD=lld",
      # "LD=clang",
    ],
    extraMakeInstallArgs =
      extraMakeArgs
      @ [
        "PREFIX=/usr",
      ],
    biDrvs = [
      drvs.binutilsObjcopy,
    ],
  }
}
