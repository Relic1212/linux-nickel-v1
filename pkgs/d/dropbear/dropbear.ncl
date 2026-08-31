{
  lib,
  drvs,
  dropbear | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://matt.ucc.asn.au/dropbear/releases/dropbear-2025.87.tar.bz2",
      sha256sum = "738b7f358547f0c64c3e1a56bbc5ef98d34d9ec6adf9ccdf01dc0bf2caa2bc8d",
    },
    extraConfigureFlags = [
      "--disable-lastlog",
      "--disable-utmp",
      "--disable-utmpx",
      "--disable-wtmp",
      "--disable-wtmpx",
    ],
    biDrvs = [
      drvs.zlibNg,
    ]
  },
  dropbearSelinux | lib.AutotoolsPackage =
    dropbear
    & {
      buildEnv = {
        EXTRA_LDFLAGS = [
          # "-lpam_dl",

          # "$(pkg-config --static --libs audit pam)",
          "$(pkg-config --libs --static libsepol libsemanage libselinux pam pam_misc libcap)",
          "/usr/lib/security/pam_gnome_keyring.a",
          "/usr/lib/security/pam_elogind.a",
        ],
      },
      extraConfigureFlags | priority 1 =
        dropbear.extraConfigureFlags
        @ [
          "--enable-shadow",
          "--enable-pam",
        ],
      biDrvs | priority 1 = [
        drvs.pkgconfMeson,
      ],
      pDrvs = [
        drvs.shadowSelinux,
        drvs.libpamSelinux,
        drvs.selinux,
        drvs.gnomeKeyring,
        drvs.elogindSelinux,
      ]
    }
}
