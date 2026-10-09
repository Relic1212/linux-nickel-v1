{
  lib,
  drvs,
  libvirtGlib | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.com/libvirt/libvirt-glib/-/archive/v5.0.0/libvirt-glib-v5.0.0.tar.bz2?ref_type=tags",
      sha256sum = "2fc117b4bbd0b34e773b4f88d386650135b9017aaeb6aa4c0c6d1f63a018b6f0",
    },
    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libacl libcap-ng libnl-3.0 libbsd gnutls json-c libcurl libtirpc libxml-2.0 glib-2.0 gobject-2.0 gio-2.0)",
      ],
    },

    preConfigurePhase = [
      m%"sed -i 's@shared_library@library@g' ${SRC}/libvirt-*/meson.build"%,
    ],
    biDrvs = [
      drvs.gnumake,
    ],
    pDrvs = [
      drvs.libvirt,
    ],
  }
}
