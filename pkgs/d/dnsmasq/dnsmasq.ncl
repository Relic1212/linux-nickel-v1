{
  lib,
  drvs,
  dnsmasq | lib.MakePackage = {
    singleSource = {
      uri = "https://thekelleys.org.uk/dnsmasq/dnsmasq-2.91.tar.xz",
      sha256sum = "f622682848b33677adb2b6ad08264618a2ae0a01da486a93fd8cd91186b3d153"
    },
    biDrvs = [
      drvs.linuxHeaders
    ],
    extraMakeArgs = [
      "SBINDIR=/usr/bin",
      "BINDIR=/usr/bin",
    ],
    extraMakeInstallArgs =
      [
        "PREFIX=/usr",
      ]
      @ extraMakeArgs,
  }
}
