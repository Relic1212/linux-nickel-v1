{
  lib,
  drvs,
  dropbear | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.87.tar.bz2",
      sha256sum = "738b7f358547f0c64c3e1a56bbc5ef98d34d9ec6adf9ccdf01dc0bf2caa2bc8d",
    },
    extraConfigureFlags = [
      "--disable-lastlog",
      "--disable-utmp",
      "--disable-utmpx",
      "--disable-wtmp",
      "--disable-wtmpx",
    ],
    biDrvs = [
      drvs.zlibNg,
    ]
  }
}
