{
  lib = {
    CmakePackage,
    Package,
    ZigPackage =
      Package
      & {
        separateBuildDir = false,
        zigBaseArgs | default = [
          "--prefix /usr"
        ],
        extraEnv = {
          "HOME" = "${SRC}/home",
        },
        zigArgs | default = [],
        zigFinalArgs | default = zigBaseArgs @ zigArgs,
        buildPhase = [
          "mkdir -p ${HOME}",
          m%"DESTDIR="${DEST}" zig build %{std.string.join " " zigFinalArgs} install"%
        ],
        utilsProviders,
        zigProvider | default = drvs.zig,
        enableCcache,
        llvmProvider,
        # llvmProvider | default = drvs.llvmFull,
        baseBuildinputPackages =
          utilsProviders
          @ [
            zigProvider,
            # drvs.llvmAllTargets,
            llvmProvider,
            drvs.musl,
            # drvs.linuxHeaders,
            drvs.pkgconfMeson,
          ]
          @ (if enableCcache then [drvs.ccacheBin] else []),
      }
  },
  lib,
  drvs,
  _zigSources = {
    "0.15.2" = {
      uri = "https://codeberg.org/ziglang/zig/archive/0.15.2.tar.gz",
      sha256sum = "8ce98a358c561432ece6245139e028c80e2acd3bf525e2d15121c62fef3a5e6c",
    },
    "0.16.0" = {
      uri = "https://codeberg.org/ziglang/zig/archive/0.16.0.tar.gz",
      sha256sum = "095d7483008e885e65d8c6a57fb97c57344f995408a648b8d50f61278ad85d7f",
    }
  },
  zig | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = _zigSources."0.16.0",
    cmakeExtraArgsRecord = {
      "-DZIG_STATIC" = true,
      "-DZIG_STATIC_CURSES" = true,
      "-DZIG_TARGET_TRIPLE" = "x86_64-linux-musl",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++"
      ],
    },

    preConfigurePhase = [
      "mkdir /tmp/home",
      "export HOME=/tmp/home",
    ],

    llvmProvider = drvs.llvmAllTargets,
    biDrvs = [
      drvs.llvmConfigStatic,
      drvs.ncurses,
      drvs.zlibNg,
      drvs.zstd,
      drvs.linuxHeaders,
    ]
  },
  llvmFull,
  llvmAllTargets | lib.CmakePackage =
    llvmFull
    & {
      cmakeExtraArgsRecord = {
        "-DLLVM_TARGETS_TO_BUILD" | priority 1 = "'all'",
        # "-DRUNTIME_CMAKE_ARGS" = "'-DLIBCXX_ENABLE_VENDOR_AVAILABILITY_ANNOTATIONS:BOOL=ON'",
        # "-DLIBCXX_ENABLE_VENDOR_AVAILABILITY_ANNOTATIONS" = true,
      }
    },
  llvmAllTargets20stage1 | lib.CmakePackage =
    llvmAllTargets
    & {
      sourceInputs | priority 1 = [
        {
          src = {

            uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.8/llvm-project-20.1.8.src.tar.xz",
            sha256sum = "6898f963c8e938981e6c4a302e83ec5beb4630147c7311183cf61069af16333d",

            #   uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.4/llvm-project-21.1.4.src.tar.xz",
            #   sha256sum = "a01ad7e5167780c945871d75c0413081d12067607a6de5cf71dc3e8d1a82112c",
          },
        }
      ],
    },
  llvmAllTargets20 | lib.CmakePackage =
    llvmAllTargets20stage1
    & {
      llvmProvider = drvs.llvmAllTargets20stage1,
    },
}
