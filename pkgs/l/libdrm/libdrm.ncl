{
  lib,
  drvs,
  libdrm | lib.MesonPackage = {

    singleSource =
      if options.new then
        {
          uri = "https://dri.freedesktop.org/libdrm/libdrm-2.4.134.tar.xz",
          sha256sum = "ac5e74d157830eb8bee44c6a6bf3ad49774ef0dd2a72bdad74a8f20308b52a95",
        }
      else
        {
          # uri = "https://dri.freedesktop.org/libdrm/libdrm-2.4.123.tar.xz",
          # sha256sum = "a2b98567a149a74b0f50e91e825f9c0315d86e7be9b74394dae8b298caadb79e",

          # uri = "https://gitlab.freedesktop.org/mesa/libdrm/-/archive/libdrm-2.4.128/libdrm-libdrm-2.4.128.tar.bz2",
          # sha256sum = "ea837ca5c339f721a42d557a039e875493514547cb164bdcf6498c703b96332e",

          uri = "https://dri.freedesktop.org/libdrm/libdrm-2.4.131.tar.xz",
          sha256sum = "45ba9983b51c896406a3d654de81d313b953b76e6391e2797073d543c5f617d5",
        },
    options = {
      new | default = (!false),
    },
    extraMesonArgs = [
      "-Dintel=enabled",
      "-Dradeon=enabled",
      "-Damdgpu=enabled",
      "-Dvmwgfx=disabled",
      "-Dnouveau=disabled",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.libpciaccess,
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

      # m%"sed -i 's@handle_table_remove@handle_table_remove_libdrm@g' ${SRC}/amdgpu/handle_table.c"%,
      # m%"sed -i 's@handle_table_remove@handle_table_remove_libdrm@g' ${SRC}/amdgpu/handle_table.h"%,
      # m%"sed -i 's@handle_table_remove@handle_table_remove_libdrm@g' ${SRC}/amdgpu/amdgpu_bo.c"%,
    ]
  },
  libdrmDebug =
    libdrm
    & {
      debug = true,
    }
}
