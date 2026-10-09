{
  lib,
  drvs,
  libtirpc | lib.AutomakePackage = {
    singleSource = {
      uri = "https://downloads.sourceforge.net/libtirpc/libtirpc-1.3.8.tar.bz2",
      sha256sum = "8839959bfcc7a0f4c609d8e4f53f1c67ae33de23775ec35beb39ff15adf11920",
    },

    preConfigurePhase = [
      # m%"sed -i 's@#include <sys/queue.h>@// #include <sys/queue.h>@g' ${SRC}/src/clnt_bcast.c ${SRC}/src/clnt_fd_locks.h"%,
    ],

    extraConfigureFlags = [
      "--disable-gssapi",
      # "--disable-ipv6",
      "--disable-symvers",
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.queueStandalone,
    ],
  },
}
