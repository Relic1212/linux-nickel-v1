{
  lib,
  drvs,
  libxkbcommon | lib.MesonPackage
    = {
      name = "libxkbcommon",

      singleSource = {
        uri = "https://xkbcommon.org/download/libxkbcommon-1.7.0.tar.xz",
        sha256sum = "65782f0a10a4b455af9c6baab7040e2f537520caa2ec2092805cdfd36863b247"
      },
      extraMesonArgs = ["-Denable-x11=false", "-Denable-xkbregistry=false"],
      biDrvs = [
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.bison,
        drvs.m4
      ]
    }
}
& {
  lib,
  drvs,
  libxkbcommon,
  libxkbcommonWithRegistry | lib.MesonPackage
    = {

      singleSource = libxkbcommon.singleSource,
      extraMesonArgs = ["-Denable-x11=false", "-Denable-xkbregistry=true"],

      buildEnv = {
        EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
        EXTRA_CXXFLAGS = ["-I/usr/include/libxml2", ],
      },

      biDrvs = [
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.libffi,
        drvs.bison,
        drvs.m4,
        drvs.libxml2,
      ]
    }
}
