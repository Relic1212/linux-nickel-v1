{
  lib,
  drvs,
  openh264 | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/cisco/openh264/archive/refs/tags/v2.6.0.tar.gz",
      sha256sum = "558544ad358283a7ab2930d69a9ceddf913f4a51ee9bf1bfb9e377322af81a69",
    },

    makeTargets = [
      "libopenh264.a",
      "binaries",
    ],
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
    makeInstallTargets = [
      "install-static",
    ],
    biDrvs = [
      drvs.nasm,
    ],
  }
}
