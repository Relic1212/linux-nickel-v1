{
  lib,
  drvs,
  glibNetworking | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/glib-networking/-/archive/2.80.0.97/glib-networking-2.80.0.97.tar.bz2",
      sha256sum = "d7594f03aa3a85d8351bac156077dc7142c141ddcda79731147c56b2e7b83f5d",
    },
    preConfigurePhase = [
      "for f in $(find ${SRC} -name meson.build);do sed -i 's|shared_module|library|g' ${f};done",
      m%"sed -i "s@static_library('giolibproxy@static_library('giolibproxy-static@g" ${SRC}/proxy/libproxy/meson.build"%,
      m%"sed -i "s@static_library('giognomeproxy@static_library('giognomeproxy-static@g" ${SRC}/proxy/gnome/meson.build"%,
      m%"sed -i "s@static_library('giognutls@static_library('giognutls-static@g" ${SRC}/tls/gnutls/meson.build"%,
    ],
    pDrvs = [
      # drvs.glib,
      drvs.libproxy,
      drvs.gnutls,
    ]
  }
}
