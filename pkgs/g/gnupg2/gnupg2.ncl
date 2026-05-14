{
  lib,
  drvs,
  gnupg2 | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.6.tar.bz2",
      sha256sum = "95acfafda7004924a6f5c901677f15ac1bda2754511d973bb4523e8dd840e17a"
    },
    biDrvs = [
      drvs.npth,
      drvs.libksba,
      drvs.gettext,
    ],
    pDrvs = [
      drvs.libassuan,
      drvs.libgcrypt,
    ],
    preConfigurePhase = [
      m%"
        sed -i 's@#include <npth.h>@#include <npth.h>\n#include <unistd.h>@g' ${SRC}/scd/app.c
        "%
    ],
    extraConfigureFlags = [
      "--disable-gnutls",
      "--enable-symcryptrun",
      "--enable-gpg-is-gpg2",
      "--disable-ldap",
      "--disable-nls",
      "--disable-doc",
    ],
    extraMakeArgs = [
      "PREFIX=/usr",
    ],
    extraMakeInstallArgs = extraMakeArgs,
    extraEnv = {
      CC_FOR_BUILD = ["clang", "-static"]
    },
    separateBuildDir = false,
  }
}
