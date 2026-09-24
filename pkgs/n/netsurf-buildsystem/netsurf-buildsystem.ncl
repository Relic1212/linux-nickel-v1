{
  lib,
  drvs,
  netsurfBuildsystem | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/netsurf-browser/buildsystem/archive/0005ae300283ff01c2e2b05e7376b3e55dea21f7.tar.gz",
      sha256sum = "94fd06e6b2948eb041f11d956fec523f98398f53fc2c2fa02982f8d15cdb381a",
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr",
    ],
  }
}
