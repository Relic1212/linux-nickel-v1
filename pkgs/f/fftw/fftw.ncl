{
  lib,
  drvs,
  fftw | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.fftw.org/fftw-3.3.10.tar.gz",
      sha256sum = "56c932549852cddcfafdab3820b0200c7742675be92179e59e6215b340e26467"
    }
  }
}
