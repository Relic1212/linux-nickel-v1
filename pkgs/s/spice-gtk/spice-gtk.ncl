{
  lib,
  drvs,
  spiceGtk | lib.MesonPackage = {
    singleSource = {
      # uri = "https://gitlab.freedesktop.org/spice/spice-gtk/-/archive/v0.43/spice-gtk-v0.43.tar.gz",
      # sha256sum = "c1a59377d1cc0a62b38854b8c8f69d9ee8c75eab90df9bb96fe6b382d1057d63",
      uri = "https://gitlab.freedesktop.org/-/project/64/uploads/88f5d31a961da9921add46ca3f0be904/spice-gtk-0.43.tar.xz",
      sha256sum = "cee26e5b2d22909f35b40a94398d1e863ca3962ee46494ca97aab206abc3203b",
    },
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "-Wl,--start-group",
        "-lc++",
        "$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
        "$(PKG_CONFIG_PATH=\"/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig\" pkg-config --libs --static gstreamer-full-1.0)",
        "$(pkg-config --libs --static gtk+-3.0)",
        # "/usr/lib/libgtk-3.a",
        "/tmp/workdir/src/libdlopen.a",
        # "-Wl,--end-group",
      ],
    },

    # extraEnv = {
    #   PKG_CONFIG_PATH = "\"/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig\"",
    # },

    extraMesonArgs = [
      # "-Dspice-common:python-checks=false",
      "-Dspice-common:tests=false",
      "-Dcoroutine=gthread",
      "-Dgtk_doc=disabled",
      "-Dintrospection=disabled",
      "-Dvapi=disabled",
    ],
    preConfigurePhase = [
      #   m%"export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig""%,
      "echo '%{import "spice_gtk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "${AR} rcs ${SRC}/libdlopen.a ${SRC}/dlopen.o",
      m%"sed -i "s@subdir('tests')@@g" ${SRC}/meson.build"%,
    ],
    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.perl,
      drvs.usbutils,
      drvs.pythonPyparsing,
    ],
    pDrvs = [
      drvs.spiceProtocol,
      drvs.gtk3,
      drvs.openssl,
      drvs.jsonGlib,
      drvs.gstreamer,
      drvs.libusb,
      drvs.polkit,
      drvs.libcapNg,
      drvs.lz4,
    ],
  }
}
