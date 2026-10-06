{
  lib,
  drvs,
  gnuLibunwind | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.6.2.tar.gz",
      sha256sum = "4a6aec666991fb45d0889c44aede8ad6eb108071c3554fcdff671f9c94794976",
    },

    postInstallPhase = [
      "cd ${DEST}/usr/lib",
      "mv libunwind.a libunwind-gnu.a",
      "sed -i 's@lunwind@lunwind-gnu@g' pkgconfig/libunwind.pc",
    ],

    biDrvs = [
      drvs.libemptyGcc,
      drvs.libempty,
    ],
  }
}
