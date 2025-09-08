{
  lib,
  drvs,
  _elogind255 | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/elogind/elogind/archive/refs/tags/v255.17.tar.gz",
      sha256sum = "a9725ae3f73f8d910de84c108bc11bfd4c782bef6a4190b2ec70c5d2f22344db",
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://raw.githubusercontent.com/alpinelinux/aports/08e9fcc9e1d8442c97807e099ab6783aa9c8d9ab/community/elogind/0007-shared-Do-not-use-malloc_info-on-musl.patch",
          sha256sum = "99964dc3f7a175ba66e2f69c43bece7e6e8b16762110c1ccfba02ba628c65ae8"
        }
      },
      {
        src = {
          uri = "https://raw.githubusercontent.com/alpinelinux/aports/refs/heads/master/community/elogind/0008-errno-util-Make-STRERROR-portable-for-musl.patch",
          sha256sum = "2b07cc0f35a7e754f51c6855a24e57424f205bc20e83c2ae2659b3e7919bd5e7"
        }
      },
      {
        src = {
          uri = "https://raw.githubusercontent.com/alpinelinux/aports/refs/heads/master/community/elogind/0009-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch",
          sha256sum = "3a0854135e448373d57affdad830153122bde6299934d120d05d70d7aa8da84a"
        },
      }
    ],

    extraMesonArgs = [
      "-Dpolkit=false",
      "-Dutmp=false",
      "-Ddefault-user-shell=/bin/sh",
      "-Dpolkit=disabled",
      "-Dman=enabled",
      "-Dstatic-libelogind=true",
      "-Dtests=false",
      "-Dsplit-bin=false",
      "-Dmode=release",
      " -Ddebug-extra=elogind",
      # "-Dlog-trace=true",
      "-Dpam=enabled",
      "-Dcgroup-controller=elogind",
      "-Ddefault-hierarchy=unified",
      "-Dudevrulesdir=/usr/lib/udev/rules.d",
      "-Dpolkit=true",
    ],

    patches = [
      {
        sha256sum = "5fbe04ddbb938039248fe72c8384e15b7045c80c1090d47b03c39fbdf1f3c521",
        file = "elogind-pam.patch"
      }
    ],
    preConfigurePhase =
      let getPatchCmd = fun patch => "(cd ${SRC} && patch -p1 < %{patch})" in
      [
        m%"    sed -i "s@ libpam_misc = cc.find_library('pam_misc', required : want_pam == 'true')@ libpam_misc = cc.find_library('pam_misc', required : false)@g" ${SRC}/meson.build"%,
        m%"sed -i 's@#include <gshadow.h>@@g' ${SRC}/src/shared/user-record-nss.h"%,
        "(cd ${SRC} && patch -p1 < 0007-shared-Do-not-use-malloc_info-on-musl.patch)",
        "(cd ${SRC} && patch -p1 < 0008-errno-util-Make-STRERROR-portable-for-musl.patch)",
        (getPatchCmd "0009-distinguish-XSI-compliant-strerror_r-from-GNU-specif.patch"),
        m%"sed -i 's@r = malloc_trim(0)@r = 0@g' ${SRC}/src/libelogind/sd-event/sd-event.c"%,
        m%"sed -i 's@struct stat last_stat;@@g' ${SRC}/src/libelogind/sd-journal/journal-file.h"%,
        "sed -i 's@linux/prctl.h@sys/prctl.h@g' ${SRC}/src/basic/missing_prctl.h",

        # libbasic.a.p/parse-util.c.o:(parse_size) in archive src/basic/libbasic.a
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/shared/conf-parser.c",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/login/pam_elogind.c",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/login/logind-user.c",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/basic/parse-util.h",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/basic/parse-util.c",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/basic/rlimit-util.h",
        "sed -i 's@ parse_size@ parse_size__elogind@g' ${SRC}/src/busctl/busctl.c",
        "sed -i 's@shared_library@library@g' ${SRC}/meson.build",
        "sed -i 's@shared_library@library@g' ${SRC}/src/shared/meson.build",

        # m%"sed -i "s@install_libelogind_static = static_library(\n        'elogind'@install_libelogind_static = static_library(\n        'elogind-static'@g" ${SRC}/meson.build"%,

        # m%"sed -i "s@static_library(\n        libshared_name@static_library(\n        'elogind-shared-255-static'@g" ${SRC}/src/shared/meson.build"%,
        m%"sed -i "s@libshared =@libshared_name += 'shared'\nlibshared =@g" ${SRC}/src/shared/meson.build"%,
        m%"sed -i "s@static_library(@static_library( 'elogind-static-' + @g" ${SRC}/meson.build"%,
        m%"
      for f in $(find ${SRC}/man -type f -name '*.xsl'); do
        sed -i 's@http://docbook.sourceforge.net/release/xsl/current@/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2@g' ${f}
      done
      "%
      ],

    postInstallPhase =
      [
        m%"sed -i 's@255@255\nRequires.private: libcap@g' ${DEST}/usr/lib/pkgconfig/libelogind.pc"%,
        "cp ${DEST}/usr/lib/security/pam_elogind.a ${DEST}/usr/lib/libpam_elogind.a",
      ]
      @ (
        let symsbols = [
          "cescape",
          "cescape_char",
          "endswith",
          "safe_atoi",
          "safe_atolli",
          "saved_argc",
          "string_hash_func",
          "string_hash_ops",
          "strv_copy",
          "strv_find",
          "strv_free",
          "strv_length",
          "strv_new_ap",
          "strv_remove",
          "strv_uniq",
          "trivial_compare_func",
          "trivial_hash_func",
          "trivial_hash_ops",
          "uint64_compare_func",
          "uint64_hash_func",
          "chmod_and_chown",
          "close_many",
          "close_nointr",
          "fd_wait_for_event",
          "flush_fd",
          "get_user_creds",
          "loop_read",
          "loop_read_exact",
          "loop_write",
          "now",
          "parse_uid",
          "path_extend_internal",
          "proc_cmdline",
          "rlimit_from_string",
          "rlimit_to_string",
          "safe_close",
          "timespec_load",
          "timespec_store",
          "timeval_store",
          "unlink_noerrno",
          "format_timespan",
          "getpeercred",
          "greedy_realloc",
          "hexchar",
          "octchar",
          "open_terminal",
          "path_compare",
          "path_strv_resolve",
          "path_strv_resolve_uniq",
          "strnappend",
          "touch_file",
          "truncate_nl",
          "unhexchar",
          "unichar_is_valid",
          "unoctchar",
          "utf16_to_utf8",
          "utf8_encode_unichar",
          "utf8_encoded_to_unichar",
          "utf8_encoded_valid_unichar",
          "utf8_is_printable_newline",
          "cmsg_close_all",
          "filename_is_valid",
          "fopen_mode_to_flags",
          "get_process_cmdline",
          "get_process_comm",
          "is_main_thread",
          "log_assert_failed",
          "log_open",
          "log_set_target",
          "mkdir_p_internal",
          "mkdir_parents_internal",
          "mkdir_safe_internal",
          "null_or_empty",
          "read_full_file_full",
          "read_full_stream_full",
          "read_one_line_file",
          "saved_argv",
          "signal_to_string",
          "warn_file_is_world_accessible",
          "xfopenat",
          "log_assert_failed_unreachable",
          "log_close",
          "log_get_max_level",
          "log_internal",
          "log_internalv",
          "log_oom_internal",
          "log_set_max_level",
          "log_target_from_string",
          "log_target_to_string",
          "page_size",
          "fopen_temporary",
          "tempfn_xxxxxx",
          "mkostemp_safe",
          "log_level_to_string_alloc",
          "log_level_from_string",
          "path_make_absolute",
          "fd_is_mount_point",
          "ascii_is_valid",
          "path_is_mount_point",
        ]
        in std.array.map (fun sym => "llvm-objcopy --redefine-sym %{sym}=elogind_private__%{sym} ${DEST}/usr/lib/libelogind.a") symsbols
      ),

    biDrvs = [
      drvs.attr,
      drvs.acl,
      drvs.dbus,
      drvs.pcre2,
      drvs.libffi,
      drvs.zlibNg,
      drvs.glib,
      drvs.libxslt,
      drvs.gudev,
      drvs.eudev,
      drvs.linuxHeaders,
      drvs.gperf,
      drvs.pythonJinja2,
      (drvs.coreutils & { priority = 1 }),
      drvs.muslGetent,
      drvs.utilLinux,
      drvs.bash,
      drvs.pythonMarkupsafe,
      drvs.pythonFlitCore,
      drvs.docbookXslNons,
    ],
    propagatedBuildInputs = [
      drvs.libpam,
      drvs.libcap,
    ]
  },
}
