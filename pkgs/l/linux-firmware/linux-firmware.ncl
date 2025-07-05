{
  lib,
  drvs,
  drvs,
  linuxFirmware | lib.MakePackage = {
    name = "linux-firmware",
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20240909.tar.gz",
      sha256sum = "93e9b6ae2240661639c874f5fc38f677d18afe365b17a13fee6b4fc4fba42c10",
    },
    # buildDir = "${SRC}",
    separateBuildDir = false,
    biDrvs = [
      drvs.rdfind,
      (drvs.coreutils & { priority = 1 }),
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
      biDrvs | priority 1 = linuxFirmware.biDrvs @ [drvs.pythonFull],
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
