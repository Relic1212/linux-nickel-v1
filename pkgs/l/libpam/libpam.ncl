{
  lib,
  drvs,
  libpam | lib.AutotoolsPackage = {
    name = "libpam",
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.6.1/Linux-PAM-1.6.1.tar.xz",
      sha256sum = "f8923c740159052d719dbfc2a2f81942d68dd34fcaf61c706a02c9b80feeef8e",
    },
    biDrvs =
      [
        drvs.linuxHeaders,
      ],
    configureFlags = std.array.filter (fun flag => (flag != "--includedir=/usr/include")) lib.AutotoolsPackage.configureFlags,
  }
}
