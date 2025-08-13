{
  lib,
  drvs,
  libfreeaptx | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/regularhunter/libfreeaptx/archive/refs/tags/0.2.2.tar.gz",
      sha256sum = "5ab5ebddf3f2eb7ce47a505b87460b00fc1ede99c70010796d3575ab31ea80bf"
    },
    extraMakeInstallArgs = [
      "PREFIX=/usr"
    ],
    patches = [
      {
        sha256sum = "3929947dc19a9258348c84167ead6505a768071f3039aeb701b9890923e49edd",
        file = "static2.patch",
      }
    ]
  }
}
