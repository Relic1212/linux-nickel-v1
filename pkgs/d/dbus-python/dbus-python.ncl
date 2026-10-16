{
  lib,
  drvs,

  dbusPython | lib.MesonPackage = {
    singleSource = {
      uri = "https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.3.2.tar.gz",
      sha256sum = "ad67819308618b5069537be237f8e68ca1c7fcc95ee4a121fe6845b1418248f8"
    },

    eofPatches = [
      { patch = import "static.patch" as 'Text },
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lffi",
        "-l:libpython3.12.a",
      ]
    },

    extraMesonArgs = [
      "-Dtests=false",
      "-Ddbus-gmain:tests=false",
    ],

    preConfigurePhase = [
      # "for f in $(find ${SRC} -type f) ; do sed -i 's|-shared|-static|g' ${f};done",
      # m%"sed -i 's@py.extension_module@library@g' ${SRC}/meson.build"%,
    ],
    pDrvs = [
      drvs.dbus,
      drvs.glib,
      # drvs.pcre2,
      # drvs.libffi,
      # drvs.zlibNg,
    ],
  }
}
& {
  lib,
  drvs,

  pythonFull,
  dbusPythonInterpreter | lib.AutotoolsPackage =
    pythonFull
    & {
      options = {
        dlopen_src | default = (import "dbus_python_init.c" as 'Text),
      },
      buildEnv.EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static dbus-1 python3 glib-2.0 gobject-2.0 girepository-2.0)",
        "-l_dbus_bindings",
        "-l_dbus_glib_bindings",
        "-l_gi",
      ],
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/dlopen.c" options.dlopen_src,
        "${CC} ${CFLAGS} $(pkg-config --cflags python3) -Werror -c ${SRC}/dlopen.c -o ${BUILDDIR}/dlopen.o",
        "ar rcs ${BUILDDIR}/libdlopen.a ${BUILDDIR}/dlopen.o",
        "ranlib ${BUILDDIR}/libdlopen.a",
        # "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/dlopen.o\"",
        "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/libdlopen.a\"",
        # "export LDFLAGS=\"${LDFLAGS} -Wl,--allow-multiple-definition=dlopen\"",
      ],
      postInstallPhase = [
        m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/_sysconfigdata__linux_x86_64-linux-gnu.py"%,
        m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/config-3.12-x86_64-linux-gnu/Makefile"%,
        "cd ${DEST}/usr",
        "rm -rf lib include share",
        "cd bin",
        "ls | grep -v python3.12|xargs rm",
        "rm python3.12-config",
        "mv python3.12 python-dbus",
      ],

      neverInclude = [
        drvs.musl
      ],
      biDrvs | priority 1 =
        pythonFull.biDrvs
        @ [
          drvs.muslBothRenamedDl,
          # drvs.musl,
          drvs.pythonFull,
        ],

      pDrvs = [
        drvs.dbusPython,
        drvs.pythonPygobjectStatic,
      ],
      allowDubplicateBuldInputs = true,
    },
}
