{
  lib,
  pkgs,
  wayland | lib.MesonPackage
    = {
      name = "wayland",
      singleSource = {
        uri = "https://gitlab.freedesktop.org/wayland/wayland/-/archive/1.23.1/wayland-1.23.1.tar.gz",
        sha256sum = "158ec49af498f2558c7fbf7e8b070d010d4e270cc6076003a18a6c813f87e244",
      },
      biDrvs =
        lib.biMap [
          pkgs.linuxHeaders,
          pkgs.expat,
          pkgs.libffi,
        ],
      extraMesonArgs = ["-Dtests=false", "-Ddocumentation=false", "-Ddtd_validation=false"],
    }
}
