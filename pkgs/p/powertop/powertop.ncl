{
  lib,
  drvs,
  powertop | lib.MesonPackage = {
    singleSource = {
      # uri = "https://github.com/fenrus75/powertop/releases/download/v2.15/powertop.tar.gz",
      # sha256sum = "e9590b82dee773b468b2eff4321a766c8bb04c45ccfa02b3127ee5af3359726b"

      # uri = "https://github.com/fenrus75/powertop/archive/49045c0c8ca7d3f47b8e289a9436d5ab2f4e93d9.tar.gz",
      # sha256sum = "ebace3bcb36cf1583db2f2c24a36ddddc8b6437eee2dd1748e802097c00a3a8c",
      # uri = "https://github.com/fenrus75/powertop/archive/refs/tags/v2.16-rc3.tar.gz",
      # sha256sum = "c1fe112ca1a79e1e308b259e2b7493f53577a937992c085189887c1a956db65c",
      uri = "https://github.com/fenrus75/powertop/archive/4faf9b946152dd66eb4e37b914cc701ad676cd8b.tar.gz",
      sha256sum = "8e17366c4fee4ca2a7ea0359035b4580543e08d3895ba5e6a4d2d43c7d7e66b4",
    },
    extraMesonArgs = [
      "-Dnls=false",
    ],

    preConfigurePhase = [
      "sed -i 's@/usr/sbin/hciconfig@/usr/bin/hciconfig@' ${SRC}/src/tuning/bluetooth.cpp",
      # "sed -i 's@/sbin/modprobe@/usr/bin/modprobe@' ${SRC}/src/main.cpp",
      "sed -i 's@/sbin/modprobe@/usr/bin/modprobe@' ${SRC}/src/main.cpp",
      "sed -i 's@/bin/mount@/usr/bin/mount@' ${SRC}/src/main.cpp",
      # m%"sed -i "s@#include <algorithm>@#include <algorithm>\n#include <unistd.h>@" ${SRC}/src/cpu/xe_gpu.cpp"%,
    ],
    # llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.ncurses,
      # drvs.gettext,
      drvs.libnl,
      drvs.linuxHeaders,
      drvs.libtraceevent,
      drvs.libtracefs,
      drvs.pciutils,
    ],
  },
}
