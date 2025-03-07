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
  },



  waylandWeaksyms = wayland & {
     postInstallPhase =
      let symbols = [
  "wl_display_interface",
"wl_registry_interface",
"wl_callback_interface",
"wl_compositor_interface",
"wl_shm_pool_interface",
"wl_shm_interface",
"wl_buffer_interface",
"wl_data_offer_interface",
"wl_data_source_interface",
"wl_data_device_interface",
"wl_data_device_manager_interface",
"wl_shell_interface",
"wl_shell_surface_interface",
"wl_surface_interface",
"wl_seat_interface",
"wl_pointer_interface",
"wl_keyboard_interface",
"wl_touch_interface",
"wl_output_interface",
"wl_region_interface",
"wl_subcompositor_interface",
"wl_subsurface_interface",
      ]
      in
      std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libwayland-server.a") symbols,
  }
}
