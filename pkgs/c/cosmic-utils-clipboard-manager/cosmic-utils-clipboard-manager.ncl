{
  lib,
  drvs,
  cosmicUtilsClipboardManager | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/cosmic-utils/clipboard-manager/archive/08a4f34022cc092302ea0f0a95457891984d4f3d.tar.gz",
      sha256sum = "f166c8dbd22bdb2130e08e2a8abc8967dee76fb79d109f0ec03182e276e4193e"
    },
    crates = lib.functions.filterCrates (import "cosmic-utils-clipboard-manager-crates.json")
  }
}
