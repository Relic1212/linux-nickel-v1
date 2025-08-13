{
  lib,
  drvs,
  gstreamer | lib.MesonPackage = {
    singleSource = {
      uri = "https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.27.1.tar.xz",
      sha256sum = "ac89913f5c39c4b216515814e63b54e865953a37dacfe149afaacdfbeb39a9f1"
    }
  }
}
