{
  lib,
  drvs,
  pengutronixGenimage | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/pengutronix/genimage/archive/refs/tags/v19.tar.gz",
      sha256sum = "f620b1cd0299c12a17f523d29cdad44075d1c87c47020bb63a98bf51901d8db5"
    },

    biDrvs = [
      drvs.libconfuse,
      drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,
  libconfuse | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/libconfuse/libconfuse/archive/refs/tags/v3.3.tar.gz",
      sha256sum = "cb90c06f2dbec971792af576d5b9a382fb3c4ca2b1deea55ea262b403f4e641e"
    },
    biDrvs = [
      drvs.flex,
      # drvs.bison,
      drvs.gettext,
    ]
  }
}
