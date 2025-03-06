{
  lib,
  drvs,
  bonsai | lib.MakePackage = {
    singleSource = {
      uri = "https://git.sr.ht/~stacyharper/bonsai/archive/v1.2.1.tar.gz",
      sha256sum = "4ddf8cd82656c874c89ea8ec9b5a198a36589bf9e1cae0346e610726e9641eaf"
    },
    # llvmProvider = drvs.llvmFull,
    isLlvm = false,
    biDrvs = [
      drvs.hare,
      drvs.harec,
      drvs.hareJson,
      drvs.hareEv,
      drvs.qbe,
      drvs.binutils,
    ],
    configurePhase = [
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",

      # "cp configs/linux.mk config.mk"
    ],
  }
}
