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
        c_src | default = (import "dbus_python_init.c" as 'Text),
      },
      buildEnv.EXTRA_LDFLAGS = [
        "$(pkg-config --libs --static dbus-1 python3 glib-2.0 gobject-2.0 girepository-2.0 libudev)",
        "-l_dbus_bindings",
        "-l_dbus_glib_bindings",
        "-l_gi",
      ],
      preConfigurePhase | priority 1 = [
        lib.functions.writeFile "${SRC}/init.c" options.c_src,
        let s = m%""g_option_error_quark","g_quark_to_string","g_error_get_type","g_io_condition_get_type","g_main_loop_get_type","g_main_context_get_type","g_source_get_type","g_io_channel_get_type","g_pollfd_get_type","g_main_loop_new","g_main_loop_get_context","g_main_loop_run","g_main_loop_quit","g_type_from_name","g_value_get_type","g_object_get_type","g_binding_get_type" "% in
        "dl-func %{std.string.join " "[

          m%"'{"names":["libglib-2.0.so.0"],"symbols":[%{s}]}'"%,
          m%"'{"names":["libgobject-2.0.so.0"],"symbols":[%{s}]}'"%,
         (
          let udev =std.string.join "," ( std.array.map (fun s => "\"%{s}\"") ["udev_new",
"udev_unref",
"udev_ref",
# "udev_get_sys_path",
# "udev_get_dev_path",
# "udev_get_run_path",
"udev_get_log_priority",
"udev_set_log_priority",
"udev_enumerate_new",
"udev_enumerate_ref",
"udev_enumerate_unref",
"udev_enumerate_add_match_subsystem",
"udev_enumerate_add_nomatch_subsystem",
"udev_enumerate_add_match_property",
"udev_enumerate_add_match_sysattr",
"udev_enumerate_add_nomatch_sysattr",
"udev_enumerate_add_match_tag",
"udev_enumerate_add_match_sysname",
"udev_enumerate_add_match_parent",
"udev_enumerate_add_match_is_initialized",
"udev_enumerate_scan_devices",
"udev_enumerate_get_list_entry",
"udev_list_entry_get_next",
"udev_list_entry_get_name",
"udev_list_entry_get_value",
"udev_device_ref",
"udev_device_unref",
"udev_device_new_from_syspath",
"udev_device_new_from_subsystem_sysname",
"udev_device_new_from_devnum",
"udev_device_new_from_device_id",
"udev_device_new_from_environment",
"udev_device_get_parent",
"udev_device_get_parent_with_subsystem_devtype",
"udev_device_get_devpath",
"udev_device_get_subsystem",
"udev_device_get_syspath",
"udev_device_get_sysnum",
"udev_device_get_sysname",
"udev_device_get_driver",
"udev_device_get_devtype",
"udev_device_get_devnode",
"udev_device_get_property_value",
"udev_device_get_sysattr_value",
"udev_device_get_devnum",
"udev_device_get_action",
"udev_device_get_seqnum",
"udev_device_get_is_initialized",
"udev_device_get_usec_since_initialized",
"udev_device_get_devlinks_list_entry",
"udev_device_get_tags_list_entry",
"udev_device_get_properties_list_entry",
"udev_device_get_sysattr_list_entry",
"udev_device_set_sysattr_value",
"udev_device_has_tag",
"udev_monitor_ref",
"udev_monitor_unref",
"udev_monitor_new_from_netlink",
"udev_monitor_enable_receiving",
"udev_monitor_set_receive_buffer_size",
"udev_monitor_get_fd",
"udev_monitor_receive_device",
"udev_monitor_filter_add_match_subsystem_devtype",
"udev_monitor_filter_add_match_tag",
"udev_monitor_filter_update",
"udev_monitor_filter_remove",
"udev_hwdb_ref",
"udev_hwdb_unref",
"udev_hwdb_new",
"udev_hwdb_get_properties_list_entry",
"udev_new",
"udev_unref",
]) in
           m%"'{"names":["libudev.so"],"symbols":[%{udev}]}'"%),

          
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
          drvs.pythonDlFunc,
        ],

      pDrvs = [
        drvs.dbusPython,
        drvs.pythonPygobjectStatic,
        drvs.eudev,
      ],
      allowDubplicateBuldInputs = true,
    },
}
