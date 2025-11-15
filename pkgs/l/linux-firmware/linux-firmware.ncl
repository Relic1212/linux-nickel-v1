{
  lib,
  drvs,
  drvs,
  linuxFirmware | lib.MakePackage = {
    singleSource = {
      uri = "https://gitlab.com/kernel-firmware/linux-firmware/-/archive/20251111/linux-firmware-20251111.tar.bz2",
      sha256sum = "8324e267819aaae01e809f73399ff52418de646201739f3e1a68067a359bacda",
    },
    # buildDir = "${SRC}",
    separateBuildDir = false,
    biDrvs = [
      drvs.rdfind,
      (drvs.coreutils & { priority = 1 }),
      (drvs.findutils & { priority = 1 }), # xtype: https://gitlab.com/kernel-firmware/linux-firmware/-/commit/121e467fde66011caa2ff64b96738cbc68dc993e
      drvs.zstd,
    ],
    makeInstallTargets = [
      "install-zst"
    ],
  },
  linuxFirmwareSmaller | lib.MakePackage =
    linuxFirmware
    & {
      name | priority 1 = "linux-firmware-smaller",
      biDrvs | priority 1 =
        linuxFirmware.biDrvs
        @ [
          drvs.pythonFull
        ],
      extraFiles = [
        {
          file = "split.py",
          sha256sum = "52a45e6a50af696b997a95417230aaeccc77b94dc4ea49b59d6bc1b86d4ac7d3"
        }
      ],
      postInstallPhase = [
        "python /tmp/workdir/files/split.py",
        "mv /tmp/workdir/out/destdir/lib/firmware.unneeded /tmp/workdir/build/firmware"
      ]
    }
}
