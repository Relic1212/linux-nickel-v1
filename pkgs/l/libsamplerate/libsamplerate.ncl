{
  lib,
  drvs,
  libsamplerate | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libsndfile/libsamplerate/releases/download/0.2.2/libsamplerate-0.2.2.tar.xz",
      sha256sum = "3258da280511d24b49d6b08615bbe824d0cacc9842b0e4caf11c52cf2b043893"
    }
  }
}