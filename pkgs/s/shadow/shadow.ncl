{
  lib,
  drvs,
  shadow | lib.AutotoolsPackage = {
    name = "shadow",
    singleSource = {
      uri = "https://github.com/shadow-maint/shadow/releases/download/4.16.0/shadow-4.16.0.tar.gz",
      sha256sum = "1744f339e07a2b41056347ddd612839762ff565d7e9494fb049428002fa2e7e0",
    },
    preConfigurePhase = [
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.am"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.in"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.am"%,
      m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.in"%,
    ],
    biDrvs = [
      drvs.pkgconf,
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
          drvs.libpamFinal,
          (drvs.libarchive & { priority = 1 }), # busybox cpio not good enough
          # drvs.elogind255,
        ],
      extraConfigureFlags | priority 1 = [
        "--with-fcaps",
        "--with-libpam",
      ],
      buildEnv.EXTRA_LDFLAGS = [
        # "-lpam_elogind",
        "-lpam_misc",
        "-lcap",
      ],
      extraMakeArgs = ["VERBOSE=1"],
      debug = true,
      options = {
        pam_elogind | default = "pam_elogind"
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
        echo "
        auth            required        pam_securetty.so debug
        auth            include         system-auth
        -auth           optional        pam_gnome_keyring.so
        account         required        pam_nologin.so
        account         include         system-auth
        password        include         system-auth
        session         include         system-auth
        session         required        pam_loginuid.so
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
    }
}
