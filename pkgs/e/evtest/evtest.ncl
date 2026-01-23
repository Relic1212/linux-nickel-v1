{
  lib,
  drvs,
  evtest | lib.AutomakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/libevdev/evtest/-/archive/evtest-1.36/evtest-evtest-1.36.tar.bz2",
      sha256sum = "aacb3bc8cc82db7890a911f743a24292a4b53b323be20f38c92d47b9392b0ba7"
    },
    biDrvs = [
      drvs.linuxHeaders,
      drvs.libevdev,
    ],
  }
}
