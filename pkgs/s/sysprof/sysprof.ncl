{
  lib,
  drvs,
  sysprof | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/sysprof/-/archive/51.0/sysprof-51.0.tar.bz2",
      sha256sum = "0c4ef598b2f5f4c6dfc9c1cf492a5ccb201ed1c83c7b9710fa298e979b2e1ced",
    },

    buildEnv = {
      EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static gtk4)",
        # "-latomic",
      ],
      EXTRA_CPPFLAGS =
        std.array.map
          (fun s => "-D%{s}=sysprof__%{s}")
          [
            "get_copy_of_container",
            "container_clone",
            "shared_container_extract_copy",
            "ra_get_key_at_index",
            "roaring_bitmap_frozen_view",
          ],
    },

    extraMesonArgs = [
      "-Dpolkit-agent=disabled",
      "-Dsysprofd=none",
      "-Dhelp=false",
      #   "-Dtools=false",
      "-Dtools=true",
      "-Dtests=false",
      "-Dexamples=false",
      "-Ddebuginfod=disabled",
      "-Dintrospection=disabled",
      "-Ddocs=false",
    ],

    preConfigurePhase = [
      m%"sed -i "s@  'sysprof-\@0\@'.format@  'sysprof-static-\@0\@'.format@g" ${SRC}/src/libsysprof/meson.build"%,
      m%"sed -i 's@shared_library@library@g' ${SRC}/src/preload/meson.build"%,
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.gnuLibunwind,
      # drvs.libemptyAtomic,
      # drvs.libempty,
      drvs.libatomicNull,
      drvs.gettext,
      drvs.desktopFileUtils,
    ],
    pDrvs = [
      # drvs.gtk4,
      drvs.libdex,
      drvs.jsonGlib,
      drvs.libpanel,
    ],
  },

  libatomicNull | lib.Package = {

    buildPhase = [
      lib.functions.writeFile "atomic.c" (import "atomic.c" as 'Text),
      "${CC} ${CFLAGS} -Werror -c atomic.c -o atomic.o",
      "${AR} rcs libatomic.a atomic.o",
      "ranlib libatomic.a",
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -m0755 libatomic.a ${DEST}/usr/lib",
    ],
    biDrvs = [
      drvs.llvm,
    ]
  },

  libunwind | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      lib.functions.writeFile "${DEST}/usr/lib/pkgconfig/libunwind-generic.pc" (import "libunwind-generic.pc" as 'Text),
    ]
  }
}
