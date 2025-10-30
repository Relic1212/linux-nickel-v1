{
  lib,
  drvs,
  stasis | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/saltnpepper97/stasis/archive/refs/tags/v0.5.2.tar.gz",
      sha256sum = "9f43b7d754ed36aae64dca6580493daeafc11879c96a8c671633322501501e74"
    },
    # enableSccache = false,
    extraEnv.EXTRA_RUSTFLAGS = [
      # "-linput",
      #  "-lm",
      #   "-ludev",
      "-C link-arg=-levdev",
      # "-lrt",
      "-C link-arg=-lmtdev"
    ],
    crates = lib.functions.filterCrates (import "stasis-crates.json"),
    biDrvs = [
      drvs.gperf,
      drvs.kmod,
      drvs.zlibNg,
      drvs.xz,
      drvs.openssl,
      drvs.zstd,
      drvs.utilLinux,
      drvs.linuxHeaders,
      drvs.eudev,
      drvs.expat,
      drvs.dbus,
      drvs.libevdev,
      drvs.libinput,
      drvs.mtdev,
    ]
  }
}
