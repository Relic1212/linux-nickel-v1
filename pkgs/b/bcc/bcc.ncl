{
  lib,
  drvs,
  bcc | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/iovisor/bcc/archive/refs/tags/v0.35.0.tar.gz",
      # sha256sum = "7adf1716d2a3df6802c3bb17664d79b9d68d7316a6773eb08d6e691c5ff0b2fc",
      uri = "https://github.com/iovisor/bcc/releases/download/v0.35.0/bcc-src-with-submodule.tar.gz",
      sha256sum = "a77c8dda4d0c0d93b5cad7b9c8539a7a180005b49ecfb0fbc3d902b5adb03ca2"
    },
    # sourceInputs = [
    #     {src = singleSource},
    #     {
    #         src = {
    #             uri = "https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.2.tar.gz",
    #             sha256sum = "16f31349c70764cba8e0fad3725cc9f52f6cf952554326aa0229daaa21ef4fbd"
    #         },
    #         dest = "src/cc/libbpf"
    #     },
    #     {
    #         src = {
    #             uri = "https://github.com/libbpf/bpftool/archive/refs/tags/v7.6.0.tar.gz",
    #             sha256sum = "66ffaadb3043b300ce94c08a10d9a5e41e5f0bc5d221d8d19a4518e35ae6448c"
    #         },
    #         dest = "libbpf-tools/bpftool"
    #     },
    #     {
    #         src = {
    #             uri  = "https://github.com/libbpf/blazesym/archive/refs/tags/v0.2.0.tar.gz",
    #             sha256sum = "343cd1f3d589aaee5a9e590d763aac1eee06875ff4aa7dd56a731302f4bc095d"
    #         },
    #         dest = "libbpf-tools/blazesym"
    #     }
    # ],

    cmakeExtraArgsRecord = {
      "-DCMAKE_USE_LIBBPF_PACKAGE" = true,
      "-DENABLE_USDT" = false,
      "-DENABLE_EXAMPLES" = false,
      "-DENABLE_TESTS" = false,
      "-DENABLE_LIBDEBUGINFOD" = false,
      "-DREVISION" = "0.35.0",
      "-DNO_BLAZESYM" = true,
      "-DENABLE_CLANG_JIT" = false,
    },
    preConfigurePhase = [
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    llvmProviders = [
      drvs.llvmFull,
      drvs.llvmConfigStatic,
    ],
    biDrvs = [
      drvs.flex,
      drvs.bison,
      drvs.linuxHeaders,
      drvs.libelf,
      drvs.git,
      drvs.xz,
      drvs.libbpf,
      drvs.zlibNg,
    ]
  }
}
& {
  lib,
  drvs,
  bccLibbpfTools | lib.MakePackage = {
    singleSource = {
      # uri = "https://github.com/iovisor/bcc/archive/refs/tags/v0.35.0.tar.gz",
      # sha256sum = "7adf1716d2a3df6802c3bb17664d79b9d68d7316a6773eb08d6e691c5ff0b2fc",
      uri = "https://github.com/iovisor/bcc/releases/download/v0.35.0/bcc-src-with-submodule.tar.gz",
      sha256sum = "a77c8dda4d0c0d93b5cad7b9c8539a7a180005b49ecfb0fbc3d902b5adb03ca2"
    },
    # sourceInputs = [
    #   {
    #     src = {
    #       uri = "https://github.com/iovisor/bcc/archive/refs/tags/v0.35.0.tar.gz",
    #       sha256sum = "7adf1716d2a3df6802c3bb17664d79b9d68d7316a6773eb08d6e691c5ff0b2fc",
    #     }
    #   },
    #   {
    #     src = {
    #       uri = "https://github.com/libbpf/libbpf/archive/refs/tags/v1.6.2.tar.gz",
    #       sha256sum = "16f31349c70764cba8e0fad3725cc9f52f6cf952554326aa0229daaa21ef4fbd"
    #     },
    #     dest = "src/cc/libbpf"
    #   },
    #   {
    #     src = {
    #       uri = "https://github.com/libbpf/bpftool/archive/refs/tags/v7.6.0.tar.gz",
    #       sha256sum = "66ffaadb3043b300ce94c08a10d9a5e41e5f0bc5d221d8d19a4518e35ae6448c"
    #     },
    #     dest = "libbpf-tools/bpftool"
    #   },
    #   {
    #     src = {
    #       uri = "https://github.com/libbpf/blazesym/archive/refs/tags/v0.2.0.tar.gz",
    #       sha256sum = "343cd1f3d589aaee5a9e590d763aac1eee06875ff4aa7dd56a731302f4bc095d"
    #     },
    #     dest = "libbpf-tools/blazesym"
    #   }
    # ],

    preConfigurePhase = [
      "cd ${SRC}/libbpf-tools",
      m%"sed -i 's|-Werror ||g' Makefile"%,
    ],
    extraMakeArgs = [
      "LLVM=1",
    ],

    makeTargets = [
      "execsnoop"
    ],
    installPhase = [],

    llvmProviders = [
      drvs.llvmFull,
      drvs.llvmConfigStatic,
    ],
    biDrvs = [
      drvs.flex,
      drvs.bison,
      drvs.linuxHeaders,
      drvs.libelf,
      drvs.xz,
      drvs.libbpf,
      drvs.zlibNg,
      drvs.pkgconf,
    ]
  }
}
