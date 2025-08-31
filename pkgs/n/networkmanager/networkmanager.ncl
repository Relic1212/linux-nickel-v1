{
  lib,
  drvs,
  networkmanager | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/archive/1.54.0/NetworkManager-1.54.0.tar.gz",
      sha256sum = "c5356e5a86b351dc79d23c8685d02b91917d1f107628c97d370c6441a8322a93"
    },
    muslProvider = drvs.muslDebug,
    biDrvs = [
      drvs.iwd,
      drvs.dbus,
      drvs.perl,
      drvs.openssl,
      drvs.ncurses,
      drvs.readline,
      drvs.libxml2,
      drvs.libxslt,
      drvs.utilLinux,
      drvs.eudevNm,
      drvs.libndp,
      drvs.glibDebug,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.openresolv,
      drvs.ppp,
      drvs.libpsl,
      drvs.curl,
      drvs.newt,
      drvs.slang,
      drvs.linuxHeaders,
      drvs.bash,
      # drvs.jansson,
    ],
    debug = true,

    extraMesonArgs = [
      "-Dtests=no",
      "-Dsession_tracking=no",
      "-Dpolkit=false",
      "-Dintrospection=false",
      "-Dsystemd_journal=false",
      "-Dsystemdsystemunitdir=no",
      "-Dselinux=false",
      "-Dlibaudit=no",
      "-Dcrypto=null",
      "-Dmodem_manager=false",
      "-Dovs=false",
      "-Dnm_cloud_setup=false",
      "-Dnbft=false",
      "-Dppp=false",
    ],
    buildEnv = {
      # https://bugs.gentoo.org/915819
      EXTRA_LDFLAGS = [
        "-Wl,--undefined-version",
        "-lncursesw",
      ]
    },
    preConfigurePhase = [
      m%"sed -i "s|subdir('nm-initrd-generator')||g" ${SRC}/src/meson.build"%,
      m%"for f in $(find ${SRC} -name meson.build); do sed -i 's@shared_library@library@g' ${f};done"%,
      m%"for f in $(find ${SRC}/tools -name '*.sh' -type f); do sed -i 's@\/bin\/bash@\/usr\/bin\/bash@g' ${f};done"%,
    ]
  }
}
& {
  lib,
  drvs,
  eudev,
  eudevNm =
    eudev
    & {
      postInstallPhase | priority 1 =
        eudev.postInstallPhase
        @ (
          let symbols = [
            "cescape_char",
            "close_many",
            "close_nointr",
            "endswith",
            "fopen_mode_to_flags",
            "format_timespan",
            "now",
            "octchar",
            "page_size",
            "path_compare",
            "path_extend_internal",
            "read_full_file_full",
            "read_full_stream_full",
            "safe_atoi",
            "safe_atolli",
            "safe_close",
            "strnappend",
            "timespec_load",
            "timespec_store",
            "warn_file_is_world_accessible",
            "cescape",
            "cmsg_close_all",
            "fd_wait_for_event",
            "filename_is_valid",
            "greedy_realloc",
            "hexchar",
            "is_dir",
            "is_main_thread",
            "loop_read",
            "loop_read_exact",
            "unhexchar",
            "unoctchar",
          ]
          in
          std.array.map
            (fun s => "llvm-objcopy --redefine-sym %{s}=udev_private__%{s} ${DEST}/usr/lib/libudev.a")
            symbols
        )
    }
}
