{
  lib,
  pkgs,
  wayland | lib.MesonPackage = {
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
    preConfigurePhase = [
      m%"sed -i 's@os_create_anonymous_file@os_create_anonymous_file_wayland_private_symbol@g' ${SRC}/cursor/os-compatibility.c"%,
      m%"sed -i 's@os_create_anonymous_file@os_create_anonymous_file_wayland_private_symbol@g' ${SRC}/cursor/os-compatibility.h"%,
      m%"sed -i 's@os_create_anonymous_file@os_create_anonymous_file_wayland_private_symbol@g' ${SRC}/cursor/wayland-cursor.c"%,
    ],
    extraMesonArgs = [
      #"-Dtests=false",
      "-Ddocumentation=false",
      "-Ddtd_validation=false"
    ],
  }
}
