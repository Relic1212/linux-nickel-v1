{
  lib,
  pkgs,
  alsaLibs | lib.AutotoolsPackage
    = {
      singleSource = {
        #https://www.alsa-project.org/wiki/Download

        uri = "http://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.12.tar.bz2",
        sha256sum = "4868cd908627279da5a634f468701625be8cc251d84262c7e5b6a218391ad0d2",
      },
      biDrvs = lib.biMap [pkgs.linuxHeaders]
    }
}
