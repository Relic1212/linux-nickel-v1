{
  lib,
  pkgs,
  libxkbcommon | lib.MesonPackage
    = {
      name = "libxkbcommon",

      singleSource = {
        uri = "https://xkbcommon.org/download/libxkbcommon-1.7.0.tar.xz",
        sha256sum = "65782f0a10a4b455af9c6baab7040e2f537520caa2ec2092805cdfd36863b247"
      },
      extraMesonArgs = ["-Denable-x11=false", "-Denable-xkbregistry=false"],
      biDrvs =
        lib.biMap [
          pkgs.wayland,
          pkgs.waylandProtocols,
          pkgs.libffi,
          pkgs.bison,
          pkgs.m4
        ]
    }
}
