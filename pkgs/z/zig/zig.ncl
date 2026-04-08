{
  lib,
  drvs,
  zig | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://codeberg.org/ziglang/zig/archive/0.15.2.tar.gz",
      # sha256sum = "8ce98a358c561432ece6245139e028c80e2acd3bf525e2d15121c62fef3a5e6c",

      # uri = "https://codeberg.org/ziglang/zig-bootstrap/archive/1e067a2d89f5eebafb41d81cfc4bf018729ab614.tar.gz",
      # sha256sum = "641558f5a2f2bffe143a5ba2c3b72fc2857694c4cc6b19333eb5a7c274d594c6",

      uri = "https://codeberg.org/ziglang/zig/archive/eb3f16db5e20a7de0695e1a42ff32526faaff9f4.zip",
      sha256sum = "1340242448a932eb6331520c31fd3cccbe0fce964f35ad9dbe94f7d35915606d",
    },
    cmakeExtraArgsRecord = {
      "-DZIG_STATIC" = true,
      "-DZIG_STATIC_CURSES" = true,
      "-DZIG_TARGET_TRIPLE" = "x86_64-linux-musl",
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
      }
    }
}
