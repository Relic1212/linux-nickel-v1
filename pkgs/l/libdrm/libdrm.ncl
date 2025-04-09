{
  lib,
  pkgs,
  drvs,
  libdrm | lib.MesonPackage = {
    name = "libdrm",
    singleSource = {
      uri = "https://dri.freedesktop.org/libdrm/libdrm-2.4.123.tar.xz",
      sha256sum = "a2b98567a149a74b0f50e91e825f9c0315d86e7be9b74394dae8b298caadb79e",
    },
    extraMesonArgs = [
      "-Dintel=enabled",
      "-Dradeon=enabled",
      "-Damdgpu=enabled",
      "-Dvmwgfx=disabled",
      "-Dnouveau=disabled",
    ],
    biDrvs =
       [
        drvs.libpciaccess,
        drvs.linuxHeaders,
      ],

    preConfigurePhase = [
      m%"
          sed -i \
            's@handle_table_remove@handle_table_remove_libdrm@g' \
            ${SRC}/amdgpu/handle_table.c
          "%,
      m%"
          sed -i \
            's@handle_table_remove@handle_table_remove_libdrm@g' \
            ${SRC}/amdgpu/handle_table.h
          "%,
      m%"
          sed -i \
            's@handle_table_remove@handle_table_remove_libdrm@g' \
            ${SRC}/amdgpu/amdgpu_bo.c
          "%,
    ]
  }
}
