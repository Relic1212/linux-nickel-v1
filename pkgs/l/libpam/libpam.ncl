{
  lib,
  drvs,
  libpam161 | lib.AutotoolsPackage = {
    name = "libpam",
    singleSource = {
      uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.6.1/Linux-PAM-1.6.1.tar.xz",
      sha256sum = "f8923c740159052d719dbfc2a2f81942d68dd34fcaf61c706a02c9b80feeef8e",
    },
    biDrvs = [
      drvs.linuxHeaders,
    ],
    configureFlags = std.array.filter (fun flag => (flag != "--includedir=/usr/include")) lib.AutotoolsPackage.configureFlags,
  }
}
& {
  lib,
  drvs,
  libpam | lib.MesonPackage =
    let pam_modules =
      #  [ "pam_unix", "pam_rootok"]
      [
        "pam_access",
        "pam_canonicalize_user",
        "pam_debug",
        "pam_deny",
        "pam_echo",
        "pam_env",
        "pam_exec",
        "pam_faildelay",
        "pam_faillock",
        "pam_filter",
        "pam_ftp",
        "pam_group",
        "pam_issue",
        "pam_keyinit",
        "pam_limits",
        "pam_listfile",
        "pam_localuser",
        "pam_loginuid",
        "pam_mail",
        "pam_mkhomedir",
        "pam_motd",
        "pam_namespace",
        "pam_nologin",
        "pam_permit",
        "pam_pwhistory",
        "pam_rootok",
        "pam_securetty",
        "pam_setquota",
        "pam_shells",
        "pam_stress",
        "pam_succeed_if",
        "pam_time",
        "pam_timestamp",
        "pam_umask",
        "pam_unix",
        "pam_usertype",
        "pam_warn",
        "pam_wheel",
        "pam_xauth"
      ]
    in
    {
      singleSource = {
        uri = "https://github.com/linux-pam/linux-pam/releases/download/v1.7.1/Linux-PAM-1.7.1.tar.xz",
        sha256sum = "21dbcec6e01dd578f14789eac9024a18941e6f2702a05cf91b28c232eeb26ab0",
      },
      patches = [
        {
          sha256sum = "d6812b8ab638dac08c534a0794a8d02d1e76789b34db9530be126f3f4b90c95b",
          file = "libpam.patch",
        }
      ],
      options = {
        isFinal | Bool | default = false,
      },
      extraMesonArgs = [
        "-Dexamples=false",
        "-Delogind=disabled",
      ],
      baseMesonArgs = (std.array.filter (fun flag => (flag != "--includedir=include")) lib.constants.mesonArgs) @ lib.constants.mesonArgsStatic,

      buildEnv.EXTRA_CFLAGS = [
        "-DHAVE_MODULE_PAM_ACCESS",
        "-DHAVE_MODULE_PAM_CANONICALIZE_USER",
        "-DHAVE_MODULE_PAM_DEBUG",
        "-DHAVE_MODULE_PAM_DENY",
        "-DHAVE_MODULE_PAM_ECHO",
        "-DHAVE_MODULE_PAM_ENV",
        "-DHAVE_MODULE_PAM_EXEC",
        "-DHAVE_MODULE_PAM_FAILDELAY",
        "-DHAVE_MODULE_PAM_FAILLOCK",
        "-DHAVE_MODULE_PAM_FILTER",
        "-DHAVE_MODULE_PAM_FILTER",
        "-DHAVE_MODULE_PAM_FTP",
        "-DHAVE_MODULE_PAM_GROUP",
        "-DHAVE_MODULE_PAM_ISSUE",
        "-DHAVE_MODULE_PAM_KEYINIT",
        "-DHAVE_MODULE_PAM_LIMITS",
        "-DHAVE_MODULE_PAM_LISTFILE",
        "-DHAVE_MODULE_PAM_LOCALUSER",
        "-DHAVE_MODULE_PAM_LOGINUID",
        "-DHAVE_MODULE_PAM_MAIL",
        "-DHAVE_MODULE_PAM_MKHOMEDIR",
        "-DHAVE_MODULE_PAM_MOTD",
        "-DHAVE_MODULE_PAM_NAMESPACE",
        "-DHAVE_MODULE_PAM_NOLOGIN",
        "-DHAVE_MODULE_PAM_PERMIT",
        "-DHAVE_MODULE_PAM_PWHISTORY",
        "-DHAVE_MODULE_PAM_ROOTOK",
        "-DHAVE_MODULE_PAM_SECURETTY",
        "-DHAVE_MODULE_PAM_SETQUOTA",
        "-DHAVE_MODULE_PAM_SHELLS",
        "-DHAVE_MODULE_PAM_STRESS",
        "-DHAVE_MODULE_PAM_SUCCEED_IF",
        "-DHAVE_MODULE_PAM_TIME",
        "-DHAVE_MODULE_PAM_TIMESTAMP",
        "-DHAVE_MODULE_PAM_UMASK",
        "-DHAVE_MODULE_PAM_UNIX",
        "-DHAVE_MODULE_PAM_USERTYPE",
        "-DHAVE_MODULE_PAM_WARN",
        "-DHAVE_MODULE_PAM_WHEEL",
        "-DHAVE_MODULE_PAM_XAUTH"
      ],
      buildEnv.EXTRA_CPPFLAGS = buildEnv.EXTRA_CFLAGS,
      # preConfigurePhase = (
      #   std.array.flatten (
      #     std.array.map
      #       (fun m =>
      #         let mod_suffix = (std.string.replace "pam_" "" m) in
      #         [
      #           "cp ${SRC}/libpam/pam_dynamic_PLACEHOLDER.h ${SRC}/libpam/pam_dynamic_%{mod_suffix }.h",
      #           "sed -i 's|PLACEHOLDER|%{m}|g' ${SRC}/libpam/pam_dynamic_%{mod_suffix }.h"
      #         ]
      #       )
      #       pam_modules
      #   )
      # ),
      postInstallPhase =
        [
          "cd ${DEST}/usr/lib/security",
        ]
        @ (
          std.array.flatten (
            std.array.map
              (fun s =>
                [
                  "llvm-objcopy --redefine-sym pam_sm_authenticate=%{s}__pam_sm_authenticate %{s}.a",
                  "llvm-objcopy --redefine-sym pam_sm_setcred=%{s}__pam_sm_setcred %{s}.a",
                  "llvm-objcopy --redefine-sym pam_sm_acct_mgmt=%{s}__pam_sm_acct_mgmt %{s}.a",
                  "llvm-objcopy --redefine-sym pam_sm_open_session=%{s}__pam_sm_open_session %{s}.a",
                  "llvm-objcopy --redefine-sym pam_sm_close_session=%{s}__pam_sm_close_session %{s}.a",
                  "llvm-objcopy --redefine-sym pam_sm_chauthtok=%{s}__pam_sm_chauthtok %{s}.a",
                  "llvm-objcopy -W _pam_line_buffer_clear %{s}.a",
                  "llvm-objcopy -W _pam_line_buffer_init %{s}.a",
                  "llvm-objcopy -W _pam_line_assemble %{s}.a",
                  "mkdir -p /tmp/workdir/build/libpam-stage-2/%{s}",
                  "(cd /tmp/workdir/build/libpam-stage-2/%{s} && llvm-ar x ${DEST}/usr/lib/security/%{s}.a)",

                  # "llvm-strip --strip-symbol=%{s}__pam_sm_authenticate ../libpam.a",
                  # "llvm-strip --strip-symbol=%{s}__pam_sm_setcred ../libpam.a",
                  # "llvm-strip --strip-symbol=%{s}__pam_sm_acct_mgmt ../libpam.a",
                  # "llvm-strip --strip-symbol=%{s}__pam_sm_open_session ../libpam.a",
                  # "llvm-strip --strip-symbol=%{s}__pam_sm_close_session ../libpam.a",
                  # "llvm-strip --strip-symbol=%{s}__pam_sm_chauthtok ../libpam.a",
                ]
              )
              pam_modules
          )
        )
        @ [

          # "cp pam_unix.so ../libpam_unix.a",
          # "cd ../pkgconfig",
          "mkdir -p /tmp/workdir/build/libpam-stage-2/libpam",
          "(cd /tmp/workdir/build/libpam-stage-2/libpam && llvm-ar x ${DEST}/usr/lib/libpam.a && rm pam_dynamic_defs.c.o)",
        ]
        @ (
          if options.isFinal then
            [
              "rm /tmp/workdir/build/libpam-stage-2/libpam/pam_dynamic_elogind.c.o",
              "mkdir /tmp/workdir/build/libpam-stage-2/pam_elogind",
              "(cd /tmp/workdir/build/libpam-stage-2/pam_elogind && llvm-ar x /usr/lib/libpam_elogind.a)",
              "(cd /tmp/workdir/build/libpam-stage-2/pam_elogind && mv '.._fundamental_bootspec-fundamental.c.o' pam_elogind_fundamental_bootspec-fundamental.c.o)",
              "(cd /tmp/workdir/build/libpam-stage-2/pam_elogind && mv '.._fundamental_sha256.c.o' pam_elogind_fundamental_sha256.c.o)",
              "(cd /tmp/workdir/build/libpam-stage-2/pam_elogind && mv '.._fundamental_string-util-fundamental.c.o' pam_elogind_fundamental_string-util-fundamental.c.o)",
              "sed -i 's|-lpam|-lpam_misc -lcap -lpam|g' ${DEST}/usr/lib/pkgconfig/pam.pc",
              "rm /tmp/workdir/build/libpam-stage-2/libpam/pam_dynamic_gnome_keyring.c.o",
              "mkdir /tmp/workdir/build/libpam-stage-2/pam_gnome_keyring",
              "(cd /tmp/workdir/build/libpam-stage-2/pam_gnome_keyring && llvm-ar x /usr/lib/security/pam_gnome_keyring.a)",
            ]
          else
            []
        )
        @ [
          # "mkdir -p /tmp/workdir/build/libpam-stage-2",
          "cd /tmp/workdir/build/libpam-stage-2",
          # "llvm-ar dv ${DEST}/usr/lib/libpam.a pam_dynamic_defs.c.o",
          # "${CC} -r -o libpam.o  %{std.string.join " -Wl,--whole-archive " (std.array.map (fun m=> "${DEST}/usr/lib/security/%{m}.a") pam_modules)} ${DEST}/usr/lib/libpam.a",
          # "${AR} rcs libpam.a libpam.o",
          "${AR} rcs libpam.a */*.o",
          "llvm-ranlib libpam.a",
          # "llvm-ar x ${DEST}/usr/lib/security/pam_unix.a && mv *.o pam_unix",
          # "llvm-ar x ${DEST}/usr/lib/libpam.a && mv *.o libpam",
          # "llvm-ar rcs libpam.a pam_unix/*.o libpam/*.o",
          "mv ${DEST}/usr/lib/libpam.a ${DEST}/usr/lib/libpam_orig.a",
          "install -m0755 libpam.a ${DEST}/usr/lib"

          # "sed -i 's|-lpam|-lpam -lpam_unix|g' pam.pc",
        ],

      biDrvs =
        [
          drvs.linuxHeaders,
        ]
        @ (
          if options.isFinal then
            [
              drvs.elogindWithPolkit,
              drvs.gnomeKeyring,
            ]
          else
            []
        ),
    },

  libpamFinal = libpam & { options.isFinal = true }
}
