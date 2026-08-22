{
  lib,
  drvs,
  auditUserspace | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/linux-audit/audit-userspace/archive/refs/tags/v4.2.1.tar.gz",
      sha256sum = "42876d195ee2ded19e5f72d7664096eee314928aa36ad346719ba5b25818fc84",
    },
    # enableParallel = false,
    # separateBuildDir = false,
    buildEnv = {
      CC = ["clang", "-static", "--static", ],
    },
    extraEnv = {
      CC_FOR_BUILD = buildEnv.CC,
    },
    extraConfigureFlags = [
      "--disable-listener",
      "--disable-zos-remote",
      "--disable-legacy-actions",
      "--disable-gssapi-krb5",
      "--without-golang",
      "--without-libwrap",
      "--without-python3",
    ],

    preConfigurePhase = [
      m%"sed -i "s@#include <stdlib.h>@#include <stdlib.h>\n#include <unistd.h>@g" ${SRC}/audisp/plugins/syslog/audisp-syslog.c"%,
    ],

    biDrvs = [
      # drvs.pythonFull,
      drvs.linuxHeaders,
    ],
    pDrvs = [
      drvs.libcap,
      drvs.openssl,
    ]
  }
}
