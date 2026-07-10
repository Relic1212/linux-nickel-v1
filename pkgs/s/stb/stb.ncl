{
  lib,
  drvs,
  stb | lib.Package = {
    singleSource = {
      uri = "https://github.com/nothings/stb/archive/31c1ad37456438565541f4919958214b6e762fb4.tar.gz",
      sha256sum = "e4e3bba9c572a4a4148373a914d88ea0f0d11de8cc2c66739926e7eca0223319",
    },

    separateBuildDir = false,

    installPhase = [
      "install -dm0755 ${DEST}/usr/include/stb",
      "install -m0755 *.h ${DEST}/usr/include/stb",
    ]
  }
}
