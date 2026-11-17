{
  lib,
  drvs,
  f2fsTools | lib.AutomakePackage = {
    singleSource = {
      uri = "https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot/f2fs-tools-1.17.0.tar.gz",
      sha256sum = "1dbc89ada373b43cc9130b47ad3f575117583ca74715e952046c88a121a2a469",
    },

    preConfigurePhase = [
      m%"sed -i "s@#include <dirent.h>@#include <dirent.h>\n#include <linux/falloc.h>@g" ${SRC}/tools/f2fs_io/f2fs_io.c"%,
    ],
    biDrvs = [
      drvs.linuxHeaders,
      drvs.queueStandalone,
    ],
  }
}
