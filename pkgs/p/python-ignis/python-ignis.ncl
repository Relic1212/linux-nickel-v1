{
  lib,
  drvs,
  pythonIgnis | lib.gpepPackage = {
    singleSource = {
      uri = "https://github.com/ignis-sh/ignis/archive/refs/tags/v0.6.0.tar.gz",
      sha256sum = "b634a4c47450fb1f1897c8e1fcc2e914193bde03bf9bb03ac9335bb58009760c",
    },
    preConfigurePhase = [
      "export HOME=/tmp/home",
      "mkdir \"${HOME}\"",
      "git config --global user.email \"you@example.com\"",
      "git config --global user.name \"Your Name\"",
      "git init",
      "git add .",
      "git commit -m 'initial commit'",
    ],
    biDrvs = [
      drvs.git,
      drvs.pythonHatchling,
      drvs.pythonPathspec,
      drvs.pythonPluggy,
      drvs.pythonImportlibMetadate,
      drvs.pythonHatchVcs,
      drvs.pythonSetuptoolsScm,
      drvs.pythonTroveClassifiers,
    ],
  }
}
&{

lib,
drvs,


  pythonFull,
  pythonIgnisInterpreter | lib.AutotoolsPackage =
    pythonFull
    & {
      options = {
        c_src | default = (import "../../d/dbus-python/dbus_python_init.c" as 'Text),
      },
      buildEnv = {
        EXTRA_LDFLAGS = [
          "$(pkg-config --libs --static dbus-1 python3 glib-2.0 gobject-2.0 girepository-2.0 libudev cairo pango gdk-pixbuf-2.0 atk cairo-gobject gtk4 gtk4-layer-shell-0 libpulse libpulse-mainloop-glib)",
          "-l_dbus_bindings",
          "-l_dbus_glib_bindings",
          "-l_gi",
          "-l_cairo",
          "-lpython_ps_util",
          "/usr/lib/ignis-gvc/libgvc.a",
        ],

        EXTRA_CPPFLAGS = [
          "-Dg_reparseDeferralEnabledDefault=python__g_reparseDeferralEnabledDefault",
          "-D_INTERNAL_trim_to_complete_utf8_characters=python___INTERNAL_trim_to_complete_utf8_characters",
        ],
      },
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/init.c" options.c_src,
        lib.functions.writeFile "${SRC}/glib.json" (let d = import "../../d/dbus-python/_glib.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gobject.json" (let d = import "../../d/dbus-python/_gobject.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gio.json" (let d = import "../../d/dbus-python/_gio.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/gtk4.json" (let d = import "_gtk4.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/atk.json" (let d = import "../../d/dbus-python/_atk.ncl" in std.serialize 'Json d),
        lib.functions.writeFile "${SRC}/cairo_gobject.json" (let d = import "../../d/dbus-python/_cairo_gobject.ncl" in std.serialize 'Json d),
         lib.functions.writeFile "${SRC}/gtk4_layer_shell.json" (let d = import "_gtk4_layer_shell.ncl" in std.serialize 'Json d),
         lib.functions.writeFile "${SRC}/gvc.json" (let d = import "_gvc.ncl" in std.serialize 'Json d),
        let s = m%""g_option_error_quark","g_quark_to_string","g_error_get_type","g_io_condition_get_type","g_main_loop_get_type","g_main_context_get_type","g_source_get_type","g_io_channel_get_type","g_pollfd_get_type","g_main_loop_new","g_main_loop_get_context","g_main_loop_run","g_main_loop_quit","g_type_from_name","g_value_get_type","g_object_get_type","g_binding_get_type","g_initially_unowned_get_type","g_binding_flags_get_type","g_main_context_default","g_io_channel_unix_new","g_value_init" "% in
        "dl-func %{std.string.join " "[
          # m%"'{"names":["libglib-2.0.so.0"],"symbols":[%{s}]}'"%,
          # m%"'{"names":["libgobject-2.0.so.0"],"symbols":[%{s}]}'"%,

          "'%{(let d = import "../../d/dbus-python/_pango.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",
          "'%{(let d = import "../../d/dbus-python/_gdk_pixbuf.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",
        
          "'%{(let d = import "../../d/dbus-python/_udev.ncl" in let d1 = std.serialize 'Json d in let s1 =std.string.replace "\n" "" d1 in std.string.replace " " "" s1)}'",


          "--file=${SRC}/glib.json",
          "--file=${SRC}/gobject.json",
          "--file=${SRC}/gio.json",
          "--file=${SRC}/gtk4.json",
          "--file=${SRC}/atk.json",
          "--file=${SRC}/cairo_gobject.json",
            "--file=${SRC}/gtk4_layer_shell.json",
            "--file=${SRC}/gvc.json",
          m%"'{"names":[],"symbols":["python_dbus_module_init"]}'"%,
        


        ]} > ${SRC}/dlopen.c",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${BUILDDIR}/dlopen.o",
        "${CC} ${CFLAGS} $(pkg-config --cflags python3) -Werror -c ${SRC}/init.c -o ${BUILDDIR}/init.o",
        "ar rcs ${BUILDDIR}/libdlopen.a ${BUILDDIR}/dlopen.o ${BUILDDIR}/init.o",
        "ranlib ${BUILDDIR}/libdlopen.a",
        # "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/dlopen.o\"",
        "export LDFLAGS=\"${LDFLAGS} ${BUILDDIR}/libdlopen.a\"",
        # "export LDFLAGS=\"${LDFLAGS} -Wl,--allow-multiple-definition=dlopen\"",
      ],
      postInstallPhase = [
        # m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/_sysconfigdata__linux_x86_64-linux-gnu.py"%,
        # m%"sed -i 's@/tmp/workdir/build/libdlopen.a@@g' ${DEST}/usr/lib/python3.12/config-3.12-x86_64-linux-gnu/Makefile"%,
        "cd ${DEST}/usr",
        "rm -rf lib include share",
        "cd bin",
        "ls | grep -v python3.12|xargs rm",
        "rm python3.12-config",
        "mv python3.12 python-ignis",
      ],

      llvmProvider = drvs.llvmFull,
      neverInclude = [
        drvs.musl,
        drvs.cairo,
        drvs.gdkPixbuf,
      ],
      biDrvs | priority 1 =
        pythonFull.biDrvs
        @ [
          drvs.muslBothRenamedDl,
          # drvs.musl,
          drvs.pythonFull,
          drvs.pythonDlFunc,
        ],

      pDrvs = [
        drvs.dbusPython,
        drvs.pythonPygobjectStatic,
        drvs.pythonPycairoStatic,
        drvs.pythonPsutil,
        drvs.eudev,
        drvs.pango,
        drvs.gdkPixbufFull,
        drvs.cairoGobject,
        drvs.gtk4,
        drvs.atSpi2Core,
         drvs.gtk4LayerShell,
         drvs.ignisGvc,
      ],
      allowDubplicateBuldInputs = true,
    },
}


