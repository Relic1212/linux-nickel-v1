{
  lib,
  perl,

  xkeyboardConfig | lib.MesonPackage = {
    name = "xkeyboard-config",
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config/-/archive/xkeyboard-config-2.42/xkeyboard-config-xkeyboard-config-2.42.tar.gz",
      sha256sum = "932ff62af3245ad248a3b659a4b1435354acdae7273bbbc61fd183fddb2e4748",
    },
    extraMesonArgs = ["-Dnls=false"],
    biDrvs =
      lib.biMap [
        perl,
      ]
  }
}
