{
  lib = {
    CmakePackage,
    Package,
    ZigPackage =
      Package
      & {
        separateBuildDir = false,
        utilsProviders,
        baseUtilsProviders =
          utilsProviders
          @ [
            drvs.zig,
            # drvs.llvmAllTargets,
            drvs.llvmFull,
            drvs.musl,
            # drvs.linuxHeaders,
            drvs.ccacheBin,
            drvs.pkgconfMeson,
          ],
      }
  },
  lib,
  drvs,
  zig | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://codeberg.org/ziglang/zig/archive/0.15.2.tar.gz",
      sha256sum = "8ce98a358c561432ece6245139e028c80e2acd3bf525e2d15121c62fef3a5e6c",

      # uri = "https://codeberg.org/ziglang/zig-bootstrap/archive/1e067a2d89f5eebafb41d81cfc4bf018729ab614.tar.gz",
      # sha256sum = "641558f5a2f2bffe143a5ba2c3b72fc2857694c4cc6b19333eb5a7c274d594c6",

      #   uri = "https://codeberg.org/ziglang/zig/archive/eb3f16db5e20a7de0695e1a42ff32526faaff9f4.zip",
      #   sha256sum = "1340242448a932eb6331520c31fd3cccbe0fce964f35ad9dbe94f7d35915606d",
    },
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

    llvmProvider = drvs.llvmAllTargets20,
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
