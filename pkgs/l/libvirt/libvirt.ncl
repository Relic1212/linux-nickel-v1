{
  lib,
  drvs,
  libvirt | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.com/libvirt/libvirt/-/archive/v12.8.0/libvirt-v12.8.0.tar.bz2",
      sha256sum = "d10e69e5767b8e2945cc851fe9e264855b1027afb673d789a04a602386d3d171",
    },
    sourceInputs = [
      { src = singleSource, },
      {
        src = {
          uri = "https://gitlab.com/keycodemap/keycodemapdb/-/archive/22b8996dba9041874845c7446ce89ec4ae2b713d/keycodemapdb-22b8996dba9041874845c7446ce89ec4ae2b713d.tar.bz2",
          sha256sum = "4bc07b2298b517c86fad4b9f7514748d864311db4c88e8453fff4944a6b880ac",
        },
        dest = "subprojects/keycodemapdb",
      },
    ],

    eofPatches = [
      {
        patch = import "libvirt.patch" as 'Text,
      },
    ],

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static libacl libcap-ng libnl-3.0 libbsd gnutls json-c libcurl libtirpc)",
      ],
    },
    extraMesonArgs = [
      "-Dnls=disabled",
      "-Ddocs=disabled",
      "-Dtests=disabled",
      "-Dlibvirtd=enabled",
      "-Ddriver_remote=enabled",
      "-Ddriver_libvirtd=enabled",
      "-Ddriver_qemu=enabled",
      "-Ddriver_network=enabled",
    ],

    preConfigurePhase = [
      m%"sed -i -e 's@shared_library@library@g' -e 's@shared_module@library@g' ${SRC}/*/meson.build ${SRC}/*/*/meson.build ${SRC}/*/*/*/meson.build"%,
      m%"sed -i 's@"const@"static const@g' ${SRC}/subprojects/keycodemapdb/tools/keymap-gen"%,
    ],

    preBuildPhase = [
      "ninja src/esx/esx_vi.generated.h src/esx/esx_vi_methods.generated.h src/esx/esx_vi_types.generated.h src/esx/esx_vi_types.generated.typedef src/esx/esx_vi_types.generated.typeenum",
    ],

    biDrvs = [
      drvs.perl,
      #   drvs.libxml2,
      drvs.libxslt,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.curl,
      drvs.attr,
      # drvs.utilLinux,
      drvs.libcapNg,
      drvs.fuse,
      # drvs.jsonC,
      drvs.libnl,
      # drvs.libssh,
      drvs.eudev,
      drvs.libpciaccess,
      # drvs.glib,
      drvs.acl,
      drvs.gnutls,
      drvs.cryptsetup,
      drvs.libbsd,
      drvs.firewalld,
      drvs.libtirpc,
      drvs.readline,
    ]
  },
}
