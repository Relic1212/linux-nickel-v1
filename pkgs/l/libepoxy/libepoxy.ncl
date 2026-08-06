{
  drvs,
  lib,

  libepoxy | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/anholt/libepoxy/archive/refs/tags/1.5.10.tar.gz",
      sha256sum = "a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15"
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
        # "-Wl,--no-gc-sections",
      ],
    },
    # patches = [
    #   {
    #     sha256sum = "befaeae6934deeef9a1bc4249b1d81ae9753fed4640857c4702cf5028698f14a",
    #     file = "libepoxy.patch"
    #   }
    # ],
    extraMesonArgs = [
      "-Dglx=no",
      "-Degl=yes",
      "-Dx11=false",
      "-Ddocs=false",
      "-Dtests=false",
    ],
    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.mesa2,
    ],
  },

  libepoxyDebug =
    libepoxy
    & {
      debug = true,
      postInstallPhase = [
        "llvm-objcopy --globalize-symbol=library_init ${DEST}/usr/lib/libepoxy.a",
      ],
    },
}
# & {
#   lib,
#   drvs,
#   libepoxy,
#   libepoxyPatched =
#     libepoxy
#     & {
#       # debug = true,
#       patches = [
#         {
#           sha256sum = "befaeae6934deeef9a1bc4249b1d81ae9753fed4640857c4702cf5028698f14a",
#           file = "libepoxy.patch"
#         }
#       ]
#     }
# }
# & {
#   libepoxy,
#   lib,
#   drvs,
#   libepoxyNoEgl | lib.MesonPackage = {
#     singleSource = libepoxy.singleSource,
#     buildEnv = {
#       EXTRA_LDFLAGS = ["-lc++"],
#     },
#     extraMesonArgs = [
#       "-Dglx=no",
#       "-Degl=no",
#       "-Dx11=false",
#       "-Ddocs=false",
#       "-Dtests=false",
#     ],
#   }
# }
& {
  lib,
  drvs,
  libepoxy,
  libepoxyX11 | lib.MesonPackage = {
    singleSource = libepoxy.singleSource,
    buildEnv = {
      EXTRA_LDFLAGS = ["-lc++"],
    },
    extraMesonArgs = [
      "-Dglx=yes",
      "-Degl=yes",
      "-Dx11=true",
      "-Ddocs=false",
      "-Dtests=false",
    ],
    llvmProvider = drvs.llvmFull,
    # biDrvs =
    #   libepoxy.biDrvs
    #   @ [
    #     drvs.libxcursor,
    #     drvs.xorgMacros,
    #     drvs.xorgproto,
    #     drvs.xtrans,
    #     drvs.libxcb,
    #     drvs.xcbProto,
    #     drvs.libxau,
    #     drvs.libx11,
    #     drvs.libxrender,
    #     drvs.libxfixes,
    #     drvs.xcbRenderutil,
    #     drvs.libxfont2,
    #     drvs.libfontenc,
    #     drvs.libxcvt,
    #     drvs.libxshmfence,
    #     # drvs.xwayland,
    #     drvs.libxkbfile,
    #     drvs.openssl,
    #     drvs.xcbUtilWm,
    #   ],

    pDrvs = [
      drvs.mesa2,
      drvs.xcbRenderutil,
    ],
  }
}
