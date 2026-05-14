{
  lib,
  drvs,
  libsndfile | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/libsndfile/libsndfile/releases/download/1.2.2/libsndfile-1.2.2.tar.xz",
      sha256sum = "3799ca9924d3125038880367bf1468e53a1b7e3686a934f098b7e1d286cdb80e"
    },
    biDrvs = [
      drvs.pythonFull,
      drvs.linuxHeaders,
    ]
  }
}
