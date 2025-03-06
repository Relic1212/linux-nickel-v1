{
  lib,
  libmd,
  pkgs,
  libbsd | lib.AutotoolsPackage = {
    name = "libbsd",
    singleSource = {
      uri = "https://libbsd.freedesktop.org/releases/libbsd-0.12.2.tar.xz",
      sha256sum = "b88cc9163d0c652aaf39a99991d974ddba1c3a9711db8f1b5838af2a14731014"
    },
    biDrvs =
      lib.biMap [
        pkgs.libmd,
      ]
  }
}
