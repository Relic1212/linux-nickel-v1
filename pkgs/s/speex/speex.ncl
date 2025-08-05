{
  lib,
  drvs,
  speex | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://downloads.xiph.org/releases/speex/speex-1.2.1.tar.gz",
      sha256sum = "4b44d4f2b38a370a2d98a78329fefc56a0cf93d1c1be70029217baae6628feea"
    }
  }
}
& {
  lib,
  drvs,
  speexdsp | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://downloads.xiph.org/releases/speex/speexdsp-1.2.1.tar.gz",
      sha256sum = "8c777343e4a6399569c72abc38a95b24db56882c83dbdb6c6424a5f4aeb54d3d"
    }
  }
}
