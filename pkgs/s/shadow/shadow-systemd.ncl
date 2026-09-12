{
  lib,
  drvs,
  shadowPam,
  shadow,
  shadowSelinux,
  shadowPamSystemd | lib.AutotoolsPackage =
    let pkg | lib.AutotoolsPackage =
      shadowSelinux
      & {
        debug = true,
        options.selinux = true,
        options.pam_elogind = "pam_systemd",
        #   buildEnv.EXTRA_LDFLAGS | priority 1 = [
        #     "-Wl,--allow-multiple-definition",

        #     #   "-lpam_systemd",
        #     #   "-lpam_misc",
        #     #   "-lcap",
        #     #   "$(pkg-config --static --libs openssl)",
        #   ],

        extraEnv = {

          # LIBS = [
          #   # "-Wl,--allow-multiple-definition",
          #   "-lpam_misc",
          #   "-lpam_systemd",
          #   # "-Wl,--no-allow-multiple-definition",
          #   "-lcap",
          #   "-lssl",
          #   "-lcrypto",
          #   "-lmount",
          # ],

          LIBS | priority 1 = [
            "$(pkg-config --libs --static libsepol libsemanage libselinux pam libucontext)",
            "/usr/lib/security/pam_gnome_keyring.a",
            "/usr/lib/security/pam_selinux.a",
            "/usr/lib/security/pam_systemd.a",
            "/usr/lib/libdl_systemd.a",
            "$(pkg-config --static --libs libkmod mount libacl)",
          ],
        },

        extraConfigureFlags | priority 2 =
          shadowSelinux.extraConfigureFlags
          @ [
            m%"LIBS="${LIBS}""%,
            m%"LIBPAM="${LIBS}""%,
          ],

        muslProvider = drvs.muslBothRenamedDl,
        biDrvs | priority 2 =
          shadow.biDrvs
          @ [
            # drvs.libpam,
            drvs.openssl,
            drvs.systemdLibdl,
            drvs.utilLinux,
            (drvs.libarchive & { priority = 1 }), # busybox cpio not good enough
            drvs.selinux,
            drvs.muslFts,
            drvs.auditUserspace,
            drvs.libpamSelinuxSystemd,
            drvs.pcre2,
            drvs.bzip2,
            drvs.gnomeKeyring,
            drvs.systemd,
            drvs.kmodRenamedSyms,
            drvs.zstd,
            drvs.xz,
            drvs.zlibNg,
            drvs.libucontext,
            drvs.acl,
            drvs.attr,
          ],
      }
    in
    pkg
    & {
      buildEnv.EXTRA_LDFLAGS | priority 3 =
        pkg.buildEnv.EXTRA_LDFLAGS
        @ [
          "-Wl,--allow-multiple-definition",
        ],
    },
}
