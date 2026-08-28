{
  lib,
  drvs,
  shadow | lib.AutotoolsPackage = {
    name = "shadow",
    singleSource = {
      # uri = "https://github.com/shadow-maint/shadow/releases/download/4.16.0/shadow-4.16.0.tar.gz",
      # sha256sum = "1744f339e07a2b41056347ddd612839762ff565d7e9494fb049428002fa2e7e0",

      # uri = "https://github.com/shadow-maint/shadow/releases/download/4.20.2/shadow-4.20.2.tar.gz",
      # sha256sum = "e5016b40541ee6fa02ea3d409547cef6e7eea9b31f0e3482e4874f87c1d0c7c5",
      uri = "https://github.com/shadow-maint/shadow/releases/download/4.18.0/shadow-4.18.0.tar.gz",
      sha256sum = "ae486ce4c0bce55c42d76d8478e428c41586f1da2f89fbf5228243fb4d849db4",
    },
    preConfigurePhase = [
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.am"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.in"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.am"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.in"%,
    ],
    biDrvs = [
      drvs.pkgconfMeson,
      drvs.libmd,
      drvs.libbsd,
      drvs.libcap,
      drvs.linuxHeaders,
    ],
    extraConfigureFlags = [
      "--with-fcaps"
    ]
  },
  shadowPam =
    shadow
    & {
      biDrvs | priority 1 =
        shadow.biDrvs
        @ [
          # drvs.libpam,
          # drvs.libpamFinal,
          (drvs.libarchive & { priority = 1 }), # busybox cpio not good enough
          # drvs.elogind255,
        ]
        @ (
          if options.selinux then
            [
              drvs.selinux,
              drvs.muslFts,
              drvs.auditUserspace,
              drvs.libpamSelinux,
              drvs.pcre2,
              drvs.bzip2,
              drvs.elogindSelinux,
              drvs.gnomeKeyring,
            ]
          else
            [drvs.libpamFinal]
        ),
      extraConfigureFlags | priority 1 =
        [
          "--with-fcaps",
          "--with-libpam",
        ]
        @ (
          if options.selinux then
            [
              "--with-selinux",
              # "LIBS=\"\""
            ]
          else
            []
        ),
      buildEnv.EXTRA_LDFLAGS =
        [
          # "-lpam_elogind",
          "-lpam_misc",
          "-lcap",
          "-Wl,--error-limit=0",
        ]
        @ (
          if options.selinux then
            [
              "$(pkg-config --libs --static libsepol)",
            ]
          else
            []
        ),

      extraEnv =
        if options.selinux then
          {

            LIBS = [
              "$(pkg-config --libs --static libsepol libsemanage libselinux pam)",
              "/usr/lib/security/pam_gnome_keyring.a",
              "/usr/lib/security/pam_elogind.a",
            ]
          }
        else
          {},

      extraMakeArgs = ["VERBOSE=1"],
      debug = true,
      options = {
        pam_elogind | default = "pam_elogind",
        selinux | default = false,
      },
      # buildEnv.EXTRA_CFLAGS = ["-DOPENPAM_STATIC_MODULES"],
      # buildEnv.EXTRA_CPPFLAGS = buildEnv.EXTRA_CFLAGS,
      postInstallPhase = [
        # m%"
        # echo "
        # account         include         system-auth
        # password        include         system-auth
        # session         include         system-auth
        # " > ${DEST}/etc/pam.d/login
        # "%,
        #   m%"
        # echo "
        # -auth            sufficient        pam_unix.so debug
        # -account         sufficient        pam_unix.so debug
        # -password        sufficient        pam_unix.so debug
        # -session         sufficient        pam_unix.so debug
        # " > ${DEST}/etc/pam.d/login
        # "%,
        m%"
        echo %{"\""}%{if options.selinux then "auth      optional pam_exec.so expose_authtok  debug  log=/var/log/unlock.log     /usr/libexec/crypto-pam" else ""}
        auth            required        pam_securetty.so debug
        auth            include         system-auth
        -auth           optional        pam_gnome_keyring.so
        account         required        pam_nologin.so
        account         include         system-auth
        password        include         system-auth%{if options.selinux then "\nsession [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so close debug" else ""}
        session         include         system-auth
        session         required        pam_loginuid.so%{if options.selinux then "\nsession [success=ok ignore=ignore module_unknown=ignore default=bad] pam_selinux.so open debug" else ""}
        -session        optional        %{options.pam_elogind}.so debug
        -session        optional        pam_gnome_keyring.so auto_start
        " > ${DEST}/etc/pam.d/login
        "%,

        # m%"echo "-session        optional        pam_elogind.so debug" >> ${DEST}/etc/pam.d/login"%, 
        m%"
        echo "
        auth            sufficient      pam_rootok.so
        # Uncomment the following line to implicitly trust users in the "wheel" group.
        #auth           sufficient      pam_wheel.so trust use_uid
        # Uncomment the following line to require a user to be in the "wheel" group.
        auth            required        pam_wheel.so use_uid
        auth            include         system-auth
        account         include         system-auth
        password        include         system-auth
        session         include         system-auth
        session         optional        pam_xauth.so
        " > ${DEST}/etc/pam.d/su
        "%,
        m%"
        echo "
        auth            required        pam_unix.so debug
        account         required        pam_unix.so debug
        password        required        pam_unix.so debug
        session         required        pam_unix.so debug
        " > ${DEST}/etc/pam.d/system-auth
        "%,
      ]
    },

  shadowPamSystemd =
    shadowPam
    & {
      debug = true,
      options.pam_elogind = "pam_systemd",
      buildEnv.EXTRA_LDFLAGS | priority 1 = [
        "-Wl,--allow-multiple-definition",

        #   "-lpam_systemd",
        #   "-lpam_misc",
        #   "-lcap",
        #   "$(pkg-config --static --libs openssl)",
      ],

      extraEnv = {

        LIBS = [
          # "-Wl,--allow-multiple-definition",
          "-lpam_misc",
          "-lpam_systemd",
          # "-Wl,--no-allow-multiple-definition",
          "-lcap",
          "-lssl",
          "-lcrypto",
          "-lmount",
        ]
      },

      extraConfigureFlags | priority 2 =
        shadowPam.extraConfigureFlags
        @ [
          m%"LIBS="${LIBS}""%,
          m%"LIBPAM="${LIBS}""%,
        ],

      muslProvider = drvs.muslBothRenamedDl,
      biDrvs | priority 2 =
        shadow.biDrvs
        @ [
          # drvs.libpam,
          drvs.libpamFinalSystemd,
          drvs.openssl,
          drvs.libpamSystemd,
          drvs.systemdLibdl,
          drvs.utilLinux,
          (drvs.libarchive & { priority = 1 }), # busybox cpio not good enough
          # drvs.elogind255,
        ],
    },
  shadowSelinux =
    shadowPam
    & {
      # muslProvider = drvs.muslBothRenamedDl,

      options.selinux = true,
      # postInstallPhase | force = [],
    },
}
