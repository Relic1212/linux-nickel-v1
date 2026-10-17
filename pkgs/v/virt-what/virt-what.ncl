{
  lib,
  drvs,
  virtWhat | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://people.redhat.com/rjones/virt-what/files/virt-what-1.27.tar.gz",
      sha256sum = "d4d9bd9d4ae59095597443fac663495315c7eb4330b872aa5f062df38ac69bf1",
    },
    biDrvs = [
      drvs.perl,
    ],
  }
}
