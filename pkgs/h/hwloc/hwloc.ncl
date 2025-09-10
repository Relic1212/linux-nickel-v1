{
  lib,
  drvs,
  hwloc | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.open-mpi.org/release/hwloc/v2.12/hwloc-2.12.2.tar.bz2",
      sha256sum = "563e61d70febb514138af0fac36b97621e01a4aacbca07b86e7bd95b85055ba0"
    },
    extraConfigureFlags = [
      "--disable-plugin-dlopen",
    ]
  }
}
