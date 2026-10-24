{
  lib,
  drvs,
  nautilus | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.gnome.org/GNOME/nautilus/-/archive/50.1/nautilus-50.1.tar.bz2",
      # sha256sum = "f107fdba54bd54fc04149f2b8a7473c0cc5c73b57403d88a06972d018015192a",

      # uri = "https://gitlab.gnome.org/GNOME/nautilus/-/archive/49.6/nautilus-49.6.tar.bz2",
      # sha256sum = "bebebb8889c237db8ca0af0cb19a32f69c1e99fd227e40b0188017555aafb32b",
      uri = "https://gitlab.gnome.org/GNOME/nautilus/-/archive/47.6/nautilus-47.6.tar.bz2",
      sha256sum = "e7f0f84e2d867a00c589301de83939b4064fd652b4fab6ff2cf5d43cdcc74ade"
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--error-limit=0",
        "-lc++",
        "/tmp/workdir/src/dlopen.o",
        "/tmp/workdir/src/constructor.o",
        "/usr/lib/tinysparql-3.0/libtracker-parser-libicu.a",
        "/usr/lib/tinysparql-3.0/libtracker-http-soup3.a",
        "$(pkg-config --libs --static tracker-sparql-3.0 icu-uc icu-i18n libsoup-3.0 libadwaita-1)",
        "-lstemmer",
      ],
    },
    extraMesonArgs = [
      "-Dextensions=false",
      "-Dintrospection=false",
      "-Dpackagekit=false",
      # "-Dselinux=disabled",
      "-Dselinux=false",
      # "-Dcloudproviders=disabled",
      "-Dcloudproviders=false",
      "-Dtests=none",
    ],
    preConfigurePhase =
      (
        std.array.map
          (fun s => "sed -i 's@shared_module@library@g' ${SRC}/%{s}")
          [
            # "libnautilus-extension/meson.build",
            "extensions/image-properties/meson.build",
            "extensions/audio-video-properties/meson.build",
          ]
      )
      @ [
        m%"sed -i "s@shared_library@library@g" ${SRC}/libnautilus-extension/meson.build"%,
        m%"sed -i 's@unsupported_protocols@nautilus_unsupported_protocols@g' ${SRC}/src/nautilus-network-address-bar.c"%,
        m%"sed -i 's@properties@nautilus_properties@g' ${SRC}/src/nautilus-progress-info.c"%,
        m%"sed -i 's@g_object_class_install_nautilus_properties@g_object_class_install_properties@g' ${SRC}/src/nautilus-progress-info.c"%,
        m%"sed -i 's@mime_type_map@nautilus_mime_type_map@g' ${SRC}/src/nautilus-file.c"%,
        lib.functions.writeFile "${SRC}/dlopen.c" (import "nautilus_dlopen.c" as 'Text),
        lib.functions.writeFile "${SRC}/constructor.c" (import "constructor.c" as 'Text),
        "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/constructor.c -o ${SRC}/constructor.o",
      ],
    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    # pythonProvider = drvs.pythonDynamic,

    neverInclude = [
      drvs.libadwaita,
    ],
    biDrvs = [
      drvs.gettext,
      drvs.desktopFileUtils,
      drvs.libadwaitaPostFixed,
    ],
    pDrvs = [
      drvs.libadwaita,
      drvs.tinysparql,
      drvs.gnomeAutoar,
      drvs.gnomeDesktop4,
      drvs.libportal,
    ],
  }
}
