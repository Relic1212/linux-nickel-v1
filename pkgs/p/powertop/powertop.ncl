{
  lib,
  drvs,
  powertop | lib.AutomakePackage = {
    singleSource = {
      # uri = "https://github.com/fenrus75/powertop/releases/download/v2.15/powertop.tar.gz",
      # sha256sum = "e9590b82dee773b468b2eff4321a766c8bb04c45ccfa02b3127ee5af3359726b"

      uri = "https://github.com/fenrus75/powertop/archive/49045c0c8ca7d3f47b8e289a9436d5ab2f4e93d9.tar.gz",
      sha256sum = "ebace3bcb36cf1583db2f2c24a36ddddc8b6437eee2dd1748e802097c00a3a8c"
    },

    configureScript,
    configureFlags,
    configurePhase = [
      # "(cd ${SRC}; NOCONFIGURE=1 ./autogen.sh)",
      "(cd ${SRC} && autoupdate)",
      "(cd ${SRC} && autoreconf -fiv)",
      "(cd ${SRC} && ./autogen.sh)",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
    preConfigurePhase = [
      "sed -i 's@/usr/sbin/hciconfig@/usr/bin/hciconfig@' ${SRC}/src/tuning/bluetooth.cpp",
      "sed -i 's@/sbin/modprobe@/usr/bin/modprobe@' ${SRC}/src/main.cpp",
    ],
    biDrvs = [
      drvs.ncurses,
      drvs.gettext,
      drvs.libnl,
      drvs.linuxHeaders,
      drvs.autoconfArchive,
      drvs.libtraceevent,
      drvs.libtracefs,
      drvs.pciutils,
    ],
  }
}
