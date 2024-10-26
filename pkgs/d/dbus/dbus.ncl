{
  lib,
  pkgs,
  dbus | lib.MesonPackage
    = {
      name = "dbus",
      singleSource = {
        uri = "https://dbus.freedesktop.org/releases/dbus/dbus-1.15.8.tar.xz",
        sha256sum = "84fc597e6ec82f05dc18a7d12c17046f95bad7be99fc03c15bc254c4701ed204"
      },

      extraMesonArgs = [
        "-Druntime_dir=/run"
      ],
      biPkgs = [
        pkgs.expat,
        pkgs.linuxHeaders,
      ],
      preConfigurePhase = [
        "sed -i 's@    post_install_exe()@    # post_install_exe()@g' ${SRC}/meson_post_install.py"
      ]
    }
}
