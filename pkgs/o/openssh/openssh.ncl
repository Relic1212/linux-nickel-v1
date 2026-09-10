{
  lib,
  drvs,
  openssh | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-10.2p1.tar.gz",
      sha256sum = "ccc42c0419937959263fa1dbd16dafc18c56b984c03562d2937ce56a60f798b2"
    },
    separateBuildDir = false,
    extraConfigureFlags = [
      "--with-mantype=man",
    ],
    biDrvs = [
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.zlibNg,
      drvs.openssl,
    ]
  },
  opensshSelinux | lib.AutotoolsPackage =
    openssh
    & {
      buildEnv = {
        EXTRA_CPPFLAGS = [
          "-Dargv_free=openssh__argv_free",
          "-Dmac_init=openssh__mac_init",
        ],
        EXTRA_LDFLAGS = [
          # "-lpam_dl",

          # "$(pkg-config --static --libs audit pam)",
          "$(pkg-config --libs --static libsepol libsemanage libselinux pam pam_misc libcap)",
          "/usr/lib/security/pam_gnome_keyring.a",
          "/usr/lib/security/pam_elogind.a",
        ],
      },
      biDrvs | priority 1 =
        openssh.biDrvs
        @ [
          drvs.pkgconfMeson,
          drvs.elogindSelinux,
          drvs.gnomeKeyring,
        ],
      extraConfigureFlags | priority 1 = [
        "--with-mantype=man",
        "--with-selinux",
        "--with-pam",
      ],
      pDrvs | priority 1 = [
        drvs.selinux,
        drvs.libpamSelinux,
      ],
    }
}
