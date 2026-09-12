{
  lib,
  drvs,
  systemd | lib.MesonPackage = {
    # debug = true,
    debug,
    singleSource = {
      uri = "https://github.com/systemd/systemd/archive/refs/tags/v261.2.tar.gz",
      sha256sum = "ed1059ff964f5df35b6056434cc17cc83f86dc913f10489948a0b19b6081c5ec"
    },

    buildEnv = {
      EXTRA_CPPFLAGS = [
        "-Dcap_last_cap=systemd__cap_last_cap",
        "-Dpid_get_cmdline=systemd__pid_get_cmdline",
      ],
      EXTRA_LDFLAGS = [
        #"-lc",
        "-ldl_systemd",
        "$(pkg-config --static --libs libkmod mount libacl libsepol libsemanage libselinux pam)",
        "-lpam_dl",
        # "-lpam_misc",
        "/tmp/workdir/src/pam_systemd.a",
        # "/usr/lib/security/pam_gnome_keyring.a",
        "/tmp/workdir/src/pam_gnome_keyring.a",
      ],
    },

    extraMesonArgs =
      [
        "-Dlibc=musl",
        "-Dtests=false",
        # "-Dstatic-libudev=no-pic",
        # "-Dpamconfdir=no",
        "-Dsplit-bin=false",
        "-Dldconfig=false",
        "-Dblkid=enabled",
        "-Dxkbcommon=enabled",
        "-Dpcre2=enabled",
        "-Dman=enabled",
        "-Dtpm2=enabled",
      ]
      @ (
        std.array.map
          (fun l => "-Dlink-%{l}-shared=false")
          [
            "udev",
            "executor",
            "systemctl",
            "networkd",
            "timesyncd",
            "journalctl",
            "boot",
            "portabled"
          ]
      )
      @ (
        if debug then
          [
            "-Dlog-trace=true",
          ]
        else
          [
            "-Dmode=release",
          ]
      ),
    preConfigurePhase = [
      m%"sed -i "s|libshared = shared_library(|libshared = shared_library( 'shared' +|g" ${SRC}/src/shared/meson.build"%,
      m%"sed -i "s|libcore = shared_library(|libcore = shared_library( 'shared' +|g" ${SRC}/src/core/meson.build"%,
      m%"sed -i "s|libudev = shared_library(|libudev = shared_library( 'shared' + |g" ${SRC}/meson.build"%,
      "for f in $(find ${SRC} -name meson.build); do sed -i 's|shared_library|library|g' ${f};done",
      # m%"sed -i 's@sym_pam@pam@g' ${SRC}/src/core/exec-invoke.c"%,
      # m%"sed -i 's@dlopen_libpam()@1@g' ${SRC}/src/core/exec-invoke.c"%,
      # m%"sed -i 's@dlopen_libpam()@1@g' ${SRC}/src/login/pam_systemd.c"%,
      # m%"sed -i 's@sym_pam@pam@g' ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i 's@DLSYM_PROTOTYPE@// DLSYM_PROTOTYPE@g' ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i "s@int dlopen_libpam(void)@#ifdef NO_SUCH_MACRO\n@g" ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i "s@void pam_log_setup(void)@#endif\nvoid pam_log_setup(void)@g" ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i 's@DLSYM_ARG@// DLSYM_ARG@g' ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i "s@DLSYM_ARG(pam_vsyslog)@DLSYM_ARG(pam_vsyslog)\n@g" ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i "s@LOG_DEBUG,\n@LOG_DEBUG\n                 //@g" ${SRC}/src/shared/pam-util.c"%,
      # m%"sed -i 's@extern DLSYM_PROTOTYPE@// extern DLSYM_PROTOTYPE@g' ${SRC}/src/shared/pam-util.h"%,
      # m%"sed -i 's@sym_pam@pam@g' ${SRC}/src/shared/pam-util.h"%,
      # m%"sed -i 's|pam_sm_close_session|pam_systemd_pam_sm_close_session|g' ${SRC}/src/login/pam_systemd.sym"%,
      # m%"sed -i 's|pam_sm_open_session|pam_systemd_pam_sm_open_session|g' ${SRC}/src/login/pam_systemd.sym"%,
      # m%"sed -i "s@'version-script'@# 'version-script'@g" ${SRC}/src/login/meson.build"%,
      # m%"sed -i "s@'-Wl,--version-script=' + d@# '-Wl,--version-script=' + d@g" ${SRC}/meson.build"%,
      # m%"sed -i "s@dict.get('version-script')@# dict.get('version-script')@g" ${SRC}/meson.build"%,
      # m%"sed -i 's@local@global@g' ${SRC}/src/login/pam_systemd.sym"%,
      "cp /usr/lib/libempty.a /tmp/workdir/src/pam_systemd.a",
      "cp /usr/lib/libempty.a /tmp/workdir/src/pam_gnome_keyring.a",
      m%"touch --no-dereference --date="@1302044400" /tmp/workdir/src/pam_systemd.a /tmp/workdir/src/pam_gnome_keyring.a"%,

      # man
      m%"sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${SRC}/man/custom-man.xsl"%,
    ],
    preBuildPhase =
      [
        "echo 'building boot'",
        "ninja src/boot/libefix64.a",
        "ninja src/boot/systemd-bootx64.elf",
        "ninja src/boot/linuxx64.elf.stub",
        "ninja src/boot/addonx64.elf.stub",
        "ninja src/boot/systemd-bootx64.efi",
        "ninja src/boot/linuxx64.efi.stub",
        "ninja src/boot/addonx64.efi.stub",
        "ninja systemd-boot",
        "echo 'building pam_systemd'",
        "ninja pam_systemd.a",
        "llvm-objcopy --redefine-sym pam_sm_open_session=pam_systemd_pam_sm_open_session pam_systemd.a",
        "llvm-objcopy --redefine-sym pam_sm_close_session=pam_systemd_pam_sm_close_session pam_systemd.a",
      ]
      @ (
        std.array.map
          (fun s => "llvm-objcopy -W %{s} pam_systemd.a"
          )
          [
            "log_internal",
            "freeze",
            "log_level_from_string",
            "log_get_max_level",
            "parse_boolean",
            "log_set_max_level",
            "log_set_max_level_from_string",
            "hexdump",
            "strv_free",
            "parse_boolean",
            "hexdump",
            "log_internal",
            "freeze",
            "log_level_from_string",
            "log_get_max_level",
            "log_set_max_level",
            "log_set_max_level_from_string",
            "strv_free",
          ]
      )
      @ [
        "cp pam_systemd.a /tmp/workdir/src/pam_systemd.a",
        "cp /usr/lib/security/pam_gnome_keyring.a /tmp/workdir/src/pam_gnome_keyring.a",
        m%"touch --no-dereference --date="@1302044400" /tmp/workdir/src/pam_systemd.a /tmp/workdir/src/pam_gnome_keyring.a"%,
      ],
    # buildPhase=[
    #   "ninja",
    # ],
    postInstallPhase =
      (
        let symbols = [
          "ascii_strlower",
          "ascii_tolower",
          "base64char",
          "cellescape",
          "cescape_char",
          "cescape_length",
          "chmod_and_chown_at",
          "cmp_int",
          "cmp_uint16",
          "cunescape_length_with_prefix",
          "cunescape_one",
          "decchar",
          "delete_chars",
          "delete_trailing_chars",
          "ellipsize_mem",
          "emoji_enabled",
          "env_assignment_is_valid",
          "env_name_is_valid",
          "env_value_is_valid",
          "escape_non_printable_full",
          "expand_to_usable",
          "extract_first_word",
          "fdopen_unlocked",
          "fflush_and_check",
          "fflush_sync_and_check",
          "first_word",
          "fmemopen_unlocked",
          "free_and_strdup",
          "free_and_strndup",
          "get_proc_field",
          "getenv_bool",
          "greedy_realloc_append",
          "greedy_realloc",
          "greedy_realloc0",
          "hexchar",
          "hexdump",
          "hexmem",
          "json_dispatch_user_group_name",
          "json_log_internal",
          "json_tokenize",
          "make_cstring",
          "memdup_suffix0",
          "memdup",
          "memeqbyte",
          "octchar",
          "open_memstream_unlocked",
          "page_size",
          "pam_acquire_bus_connection",
          "pam_bus_data_disconnectp",
          "pam_cleanup_free",
          "pam_syslog_errno",
          "pam_syslog_pam_error",
          "parse_boolean",
          "parse_fd",
          "parse_ifindex",
          "parse_pid",
          "parse_tristate_full",
          "path_make_absolute_cwd",
          "quote_command_line",
          "read_full_file_full",
          "read_full_stream_full",
          "read_line_full",
          "read_one_line_file_at",
          "read_virtual_file_at",
          "readlink_value",
          "readlinkat_malloc",
          "rename_noreplace",
          "safe_atod",
          "safe_atoi",
          "safe_atoi16",
          "safe_atolli",
          "safe_atollu_full",
          "safe_atou_bounded",
          "safe_atou_full",
          "safe_atou16_full",
          "safe_atou8_full",
          "safe_fgetc",
          "set_unset_env",
          "shell_maybe_quote",
          "strdupcspn",
          "streq_skip_trailing_chars",
          "strextend_with_separator_internal",
          "strextendf_with_separator",
          "string_contains_word_strv",
          "string_extract_line",
          "string_has_cc",
          "string_is_safe",
          "string_replace_char",
          "string_truncate_lines",
          "strlevenshtein",
          "strshorten",
          "strspn_from_end",
          "strstrip",
          "strv_compare",
          "strv_consume_prepend",
          "strv_consume_with_size",
          "strv_copy_n",
          "strv_copy_unless_empty",
          "strv_env_replace_consume",
          "strv_env_replace_strdup",
          "strv_env_unset",
          "strv_extend_assignment",
          "strv_extend_n",
          "strv_extend_strv",
          "strv_extend_with_size",
          "strv_find_case",
          "strv_find_startswith",
          "strv_find",
          "strv_fnmatch_full",
          "strv_free_erase",
          "strv_free_many",
          "strv_free",
          "strv_insert",
          "strv_join_full",
          "strv_length",
          "strv_new_ap",
          "strv_new_internal",
          "strv_print_full",
          "strv_push_pair",
          "strv_push_with_size",
          "strv_remove",
          "strv_skip",
          "strv_sort",
          "strv_split_full",
          "strv_split_newlines_full",
          "strv_uniq",
          "strverscmp_improved",
          "take_fdopen_unlocked",
          "take_fdopen",
          "take_fdopendir",
          "truncate_nl_full",
          "unbase64char",
          "unbase64mem_full",
          "undecchar",
          "unhexchar",
          "unhexmem_full",
          "unoctchar",
          "verify_file_at",
          "version_is_valid",
          "warn_file_is_world_accessible",
          "write_string_filef",
          "xescape_full",
          "xfopenat_full",
          "xopendirat",
        ]
        in
        std.array.map
          (fun s => "llvm-objcopy --redefine-sym %{s}=pam_systemd_private__%{s} ${DEST}/usr/lib/security/pam_systemd.a")
        # (fun s => "llvm-objcopy -W %{s} ${DEST}/usr/lib/security/pam_systemd.a")
        # symbols
          []
      )
      @ [
        "(cd ${DEST}/usr/bin && ln -s ../lib/systemd/systemd-udevd udevd)",
        "install -d -m0755 ${DEST}/usr/libexec",
        "(cd ${DEST}/usr/libexec && ln -s ../lib/systemd/systemd-logind elogind)",
        m%"for f in $(find ${DEST}/usr/share/dbus-1/ -type f); do sed -i 's@\/bin\/false@\/usr\/bin\/true@g' ${f};done"%,
        m%"for symbol in $(llvm-nm ${DEST}/usr/lib/security/pam_systemd.a | grep ' t pam' | cut -d ' ' -f3); do echo "globalizing ${symbol}"; llvm-objcopy --globalize-symbol ${symbol} ${DEST}/usr/lib/security/pam_systemd.a;done"%,
        ###
        "llvm-objcopy --redefine-sym pam_sm_open_session=pam_systemd_pam_sm_open_session ${DEST}/usr/lib/security/pam_systemd.a",
        "llvm-objcopy --redefine-sym pam_sm_close_session=pam_systemd_pam_sm_close_session ${DEST}/usr/lib/security/pam_systemd.a",
        ###
        "cp ${DEST}/usr/lib/security/pam_systemd.a ${DEST}/usr/lib/libpam_systemd.a",

        ###
        m%"sed -i 's@/usr/bin/agetty --noreset@/usr/bin/agetty --login-program /usr/bin/login --noreset@g' ${DEST}/usr/lib/systemd/system/*.service"%,
      ],

    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.systemdLibdl,
      # drvs.acl,
      # drvs.dbus,
      # drvs.zlibNg,
      # drvs.zstd,
      # drvs.xz,
      drvs.gettext,
      drvs.basefiles,
      drvs.gnugrep,
      drvs.pythonDynamic,
      drvs.pythonJinja2,
      # drvs.bash,
      # drvs.coreutils,
      #   drvs.muslShared,
      drvs.pythonFlitCore,
      drvs.pythonMarkupsafe,
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.pythonElftools,
      drvs.muslGetent,
      drvs.gnomeKeyring,
      drvs.libempty,
      drvs.libxslt,
      drvs.docbookXslNons,
      drvs.docbookXml,
      # drvs.docbookSymlink,

      # drvs.libpam,
      # drvs.busyboxMiscUtils,
      drvs.tpm2Tss,
    ],

    neverInclude = [
      drvs.kmod,
      drvs.libpam,
    ],

    pDrvs = [
      # drvs.libpamSelinux,
      drvs.libpamSelinuxSystemd,
      drvs.utilLinux,
      drvs.libarchive,
      drvs.kmodRenamedSyms,
      # drvs.libcap,
      drvs.acl,
      drvs.dbus,
      drvs.libucontext,
      drvs.libxkbcommon,
      drvs.curl,
      # drvs.pcre2,
      # drvs.bzip2,
      drvs.selinux,
    ],
    # pulls in static python otherwise
    baseBuildinputPackages = [
      drvs.bash,
      drvs.coreutils,
      drvs.bashSh,
      drvs.meson,
      drvs.samurai,
      drvs.pkgconfMeson,
      drvs.llvm,
      drvs.ccacheBin,
      muslProvider,
      drvs.diffutils,
      drvs.gnupatch,
      drvs.gnused,
      drvs.findutils,
      drvs.gawk,
    ],
  },
}
& {
  lib,
  drvs,
  libpamSystemd | lib.Package = {
    biDrvs = [
      drvs.systemd,
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -m0755 /usr/lib/libpam_systemd.a ${DEST}/usr/lib",
    ]
  }
}
& {
  lib,
  drvs,
  systemdLibdl | lib.Package = {
    buildPhase = [
      lib.functions.writeFile "systemd_dlopen.c" (import "systemd_dlopen2.c" as 'Text),
      "${CC} ${CFLAGS} -c -Werror systemd_dlopen.c -o systemd_dlopen.o",
      "${AR} rcs libdl_systemd.a systemd_dlopen.o",
    ],
    installPhase = [
      "install -Dm0755 libdl_systemd.a ${DEST}/usr/lib/libdl_systemd.a",
    ],
    enableCcache = false,
    biDrvs = [
      drvs.llvm,
      drvs.musl,
      # drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,
  systemdWrapped | lib.Package = {
    buildPhase = [
      lib.functions.writeFile "systemd-wrapped" (import "systemd.sh" as 'Text),
      "chmod +x systemd-wrapped",
    ],
    installPhase = [
      "install -Dm0755 systemd-wrapped ${DEST}/usr/lib/systemd/systemd-wrapped",
    ]
  }
}
& {
  lib,
  drvs,
  systemdSyscalls | lib.Package = {
    buildPhase = [
      lib.functions.writeFile "syscalls.c" (import "systemd_syscalls.c" as 'Text),
      "${CC} ${CFLAGS} -Werror syscalls.c -o syscalls",
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "install -m0755 syscalls ${DEST}/usr/bin",
    ],

    biDrvs = [
      drvs.musl,
      drvs.llvm,
      drvs.linuxHeaders,
    ]
  }
}
& {
  lib,
  drvs,
  docbookSymlink | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/share/xml/docbook",
      "cd ${DEST}/usr/share/xml/docbook",
      "ln -s xsl-stylesheets-nons-1.79.2 current",
      "install -dm0755 ${DEST}/usr/share/xml/docbook/stylesheet/",
      "cd ${DEST}/usr/share/xml/docbook/stylesheet/",
      "ln -s /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 docbook-xsl-ns",
      "ln -s /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2 docbook-xsl",
    ]
  },

  systemdVt | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/systemd/system",
      "cd ${DEST}/usr/lib/systemd/system",
      "ln -s getty@.service autovt@.service",
    ],
  },
}
