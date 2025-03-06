{
  lib,
  drvs,
  sndiod | lib.AutotoolsPackage = {

    singleSource = {
      uri = "https://sndio.org/sndio-1.10.0.tar.gz",
      sha256sum = "bebd3bfd01c50c9376cf3e7814b9379bed9e17d0393b5113b7eb7a3d0d038c54"
    },
    biDrvs = [
      drvs.alsaLibs,
      drvs.libbsd,
      drvs.libmd
    ],
    separateBuildDir = false,
    configureFlags = [
      "--prefix=/usr",
      "--exec-prefix=/usr",
      "--bindir=/usr/bin",
      "--includedir=/usr/include",
      "--libdir=/usr/lib",
      "--enable-alsa",
      "--disable-sun",
      "--enable-rmidi",
      "--enable-umidi",
      "--enable-static",
      "--with-libbsd",
    ]
  }
}
