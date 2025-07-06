{
  lib,
  pythonDynamic,
  muslShared,
  libxml2Dynamic,

  itstool | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/itstool/itstool/archive/refs/tags/2.0.7.tar.gz",
      sha256sum = "fba78a37dc3535e4686c7f57407b97d03c676e3a57beac5fb2315162b0cc3176",
    },
    biDrvs =
      lib.biMap [
        pythonDynamic,
        muslShared,
        libxml2Dynamic,
      ]
  }
}
