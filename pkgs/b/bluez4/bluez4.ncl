{
    lib,
    drvs,
    bluez4|lib.AutotoolsPackage = {
        singleSource = {
            uri = "http://www.kernel.org/pub/linux/bluetooth/bluez-4.101.tar.xz",
            sha256sum = "41f9578bef39b8c94a2d6ddeaa556afd22d136936d0f03100e422fe970a45a7d"
        },
        biDrvs = [
             drvs.dbus,
        drvs.pcre2,
        drvs.libffi,
        drvs.zlibNg,
        drvs.glib,
        drvs.linuxHeaders,
        drvs.pkgconf,
        drvs.eudev,
        drvs.gperf,
        drvs.kmod,
        drvs.xz,
        drvs.utilLinux,
        drvs.readline,
        drvs.ncurses,
        drvs.jsonC,
        drvs.alsaLibs,  
        ],
        extraConfigureFlags=[
            "--enable-alsa",
            "--enable-tools",
            "--without-pic",
            "--enable-dbusoob",
            "--enable-datafiles",
            "--enable-pcmcia",
            "--disable-usb",
            "--enable-input",
            "--enable-serial",
            "--enable-test-programs",
            "--enable-hid2hci",
            "--enable-audio",
            "--enable-bccmd",
            "--enable-dfutool",
            "--enable-network",
            "--enable-service",
            "--disable-hal",
            "--enable-health",
            "--enable-maemo6",
            "--enable-pnat",
            "--enable-wiimote",

        ],
        separateBuildDir = false,

        preConfigurePhase = [
            m%"sed -i 's@#include "ipc.h"@#include "ipc.h"\n#include <string.h>@g' ${SRC}/audio/ipc.c"%,

            m%"sed -i 's@#include <sys/ioctl.h>@#include <sys/ioctl.h>\n#include <sys/uio.h>@g' ${SRC}/tools/hciattach_tialt.c"%,

            m%"sed -i 's@#include <sys/ioctl.h>@#include <sys/ioctl.h>\n#include <sys/uio.h>@g' ${SRC}/tools/hciattach_qualcomm.c"%,

            m%"sed -i 's@#include <sys/param.h>@#include <sys/param.h>\n#include <sys/types.h>@g' ${SRC}/src/textfile.c"%,

            m%"sed -i 's@#define __TEXTFILE_H@#define __TEXTFILE_H\n#include <sys/types.h>@g' ${SRC}/src/textfile.h"%,

            # https://github.com/blueman-project/blueman/issues/273#issuecomment-102427989
            m%"sed -i 's@NULL, NULL, connection_connect) },@GDBUS_ARGS({"uuid", "s"}),\nGDBUS_ARGS({"interface", "s"}),\nconnection_connect) },@g' ${SRC}/network/connection.c"%,



        ],

        buildEnv = {
        EXTRA_LDFLAGS = [
          "-lreadline",
          "-lncursesw",
          "-Wl,--undefined-version",
        ]
      },
      extraEnv = {
        LIBS = buildEnv.EXTRA_LDFLAGS,
      },
      postInstallPhase = [
        "install -d -m0755 ${DEST}/usr/libexec/bluetooth",
        "mv ${DEST}/usr/bin/bluetoothd ${DEST}/usr/libexec/bluetooth/",

        # m%"sed -i 's@sbin\/bluetoothd@libexec\/bluetooth\/bluetoothd@g' ${DEST}/usr/lib/udev/rules.d/97-bluetooth.rules"%
      ]
    }
}

&

{
  lib,
  drvs,
  bluezLibs | lib.AutotoolsPackage = {
    singleSource = {
      uri = "http://bluez.sf.net/download/bluez-utils-2.25.tar.gz",
      sha256sum = "2"
    }
  }
}