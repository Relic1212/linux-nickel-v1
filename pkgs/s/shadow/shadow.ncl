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
          drvs.openpam,
        ],
      extraConfigureFlags | priority 1 = [
        "--with-fcaps",
        "--with-libpam",
      ],
      extraMakeArgs = ["VERBOSE=1"],
      debug = true,
      buildEnv.EXTRA_CFLAGS = ["-DOPENPAM_STATIC_MODULES"],
      buildEnv.EXTRA_CPPFLAGS = buildEnv.EXTRA_CFLAGS,
      postInstallPhase = [
        # m%"
        # echo "
        # account         include         system-auth
        # password        include         system-auth
        # session         include         system-auth
        # " > ${DEST}/etc/pam.d/login
        # "%,
        m%"
      echo "
      -auth            sufficient        pam_permit.so debug
      -account         sufficient        pam_permit.so debug
      -password        sufficient        pam_permit.so debug
      -session         sufficient        pam_permit.so debug
      " > ${DEST}/etc/pam.d/login
      "%,
      ]
    }
}
