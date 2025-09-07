{
  lib,
  fscryptUnlockHome | lib.Package = {
    extraFiles = [
      {
        file = "crypto-login.sh",
        sha256sum = "413cc7d7257f285d469088d3bb13662e886fb253ae6d14002bd9ee151c9b8597",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
& {
  lib,
  fscryptUnlockHomeElogind | lib.Package = {
    extraFiles = [
      {
        file = "crypto-login-elogind.sh",
        sha256sum = "96e3428dfee5ff5fb3b853a52148f63cc9063eb85f181b5324234e0631fb525d",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login-elogind.sh ${DEST}/usr/bin/crypto-login",
    ]
  }
}
& {
  lib,
  fscryptUnlockHomeAgreety | lib.Package = {
    extraFiles = [
      {
        file = "crypto-login-elogind.sh",
        sha256sum = "96e3428dfee5ff5fb3b853a52148f63cc9063eb85f181b5324234e0631fb525d",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/bin",
      "install -m0755 /tmp/workdir/files/crypto-login-elogind.sh ${DEST}/usr/bin/crypto-agreety",
      "sed -i 's|login|agreety|g' ${DEST}/usr/bin/crypto-agreety",
    ]
  }
}
& {
  lib,
  drvs,
  cryptoPam | lib.Package = {
    extraFiles = [
      {

        file = "crypto-pam.sh",

        sha256sum = "3b068f2c0ae3c9546249d0fcaf2aa8e3edcbea09430cbaa30c2959d1e1c87f08",
      }
    ],
    installPhase = [
      "install -d -m0755 ${DEST}/usr/libexec",
      "install -m0755 /tmp/workdir/files/crypto-pam.sh ${DEST}/usr/libexec/crypto-pam",
      "install -d -m0755 ${DEST}/etc/pam.d",
      m%"
        echo "
        auth            optional pam_exec.so expose_authtok  debug  log=/var/log/unlock.log     /usr/libexec/crypto-pam
        auth            required        pam_securetty.so debug
        auth            include         system-auth
        -auth           optional        pam_gnome_keyring.so
        account         required        pam_nologin.so debug
        account         include         system-auth
        password        include         system-auth
        session         include         system-auth
        session         required        pam_loginuid.so
        -session        optional        pam_elogind.so debug
        -session        optional        pam_gnome_keyring.so auto_start
        " > ${DEST}/etc/pam.d/greetd
        "%,
    ]
  }
}
