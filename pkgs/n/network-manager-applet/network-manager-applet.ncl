{
  lib,
  drvs,
  distro,
  networkmanager,
  networkmanagerP11Kit =
    networkmanager
    & {
      postInstallPhase | priority 1 =
        networkmanager.postInstallPhase
        @ [
          "objcopy --redefine-sym memdup=memdup_libnm ${DEST}/usr/lib/libnm.a",
        ],
    },
  gcr,
  gcrGnutls =
    gcr
    & {
      postInstallPhase | priority 1 =
        gcr.postInstallPhase
        @ [
          "objcopy --redefine-sym pkix_asn1_tab=pkix_asn1_tab_gcr ${DEST}/usr/lib/libgcr-base-3.a",
        ],
    },

  networkManagerApplet | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/network-manager-applet/-/archive/1.36.0/network-manager-applet-1.36.0.tar.bz2",
      sha256sum = "cd33839ca0b7e9d8bb12d124ca3c91943e1fff277839b3ed9e3da629c3cd73a9",
    },

    extraMesonArgs = [
      "-Dappindicator=no",
      "-Dwwan=false",
      "-Dselinux=false",
      # "-Dteam=false",
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
        # "$(pkg-config --libs --static libnma)",
      ],
    },
    preConfigurePhase = [
      "sed -i 's@#include <gdk/gdkx.h>@@g' ${SRC}/src/connection-editor/nm-connection-list.c",
      "sed -i 's@#include <gdk/gdkx.h>@@g' ${SRC}/src/connection-editor/nm-connection-editor.c",
      "sed -i 's@#include <gdk/gdkx.h>@@g' ${SRC}/src/applet.h",
      "echo > ${SRC}/shared/nm-utils/nm-shared-utils.c",
      #   "echo > ${SRC}/src/utils/utils.c",
      #   m%"sed -i "s|link_args: '-Wl,--version-script,@0@'.format(linker_script_ver),||g" ${SRC}/src/connection-editor/meson.build"%,
      m%"sed -i "s|link_args: '-Wl,--version-script,@0@'.format(linker_script_ver),|link_args: '/tmp/workdir/src/constructor.o',|g" ${SRC}/src/connection-editor/meson.build"%,
      m%"sed -i "s|link_args: '-Wl,--version-script,@0@'.format(linker_script_ver),||g" ${SRC}/src/meson.build"%,
      "echo '%{import "nm_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "echo '%{import "nm_constructor.c" as 'Text}' > ${SRC}/constructor.c",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/constructor.c -o ${SRC}/constructor.o",
      m%"sed -i "s@subdir('src/tests')@# subdir('src/tests')@g" ${SRC}/meson.build"%,
    ],

    muslProvider = drvs.muslBothRenamedDl,

    biDrvs =
      [
        drvs.gcrGnutls,
        drvs.p11Kit,
        drvs.gnupg2,
        drvs.jansson,
        drvs.atSpi2Core,
        drvs.bash,
        drvs.cairo,
        drvs.cairoGobject,
        drvs.curl,
        drvs.dbus,
        drvs.dnsmasq,
        drvs.docbookXml,
        drvs.docbookXslNons,
        drvs.elogindNm,
        drvs.eudevNm,
        drvs.expat,
        drvs.fontconfig,
        drvs.freetype,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.gettext,
        # drvs.glibPatched,
        drvs.glibDynamic,
        drvs.gmp,
        drvs.gnutls,
        drvs.gobjectDynamic,
        drvs.gperf,
        drvs.gpgme,
        drvs.graphene,
        drvs.gtk3,
        drvs.gtk4,
        drvs.harfbuzzFull,
        drvs.hwdata,
        drvs.isoCodes,
        drvs.iwd,
        drvs.libassuan,
        drvs.libcap,
        drvs.libdrm,
        drvs.libedit,
        drvs.libelf,
        drvs.libepoxy,
        drvs.libffi,
        drvs.libgcrypt,
        drvs.libgpgError,
        drvs.libjpegTurbo,
        drvs.libmnl,
        drvs.libndp,
        drvs.libnma,
        drvs.libnftnl,
        drvs.libpam,
        drvs.libpciaccess,
        drvs.libpng,
        drvs.libpsl,
        drvs.libsecret,
        drvs.libtasn1,
        drvs.libtiff,
        drvs.libxkbcommon,
        drvs.libxml2,
        drvs.libxslt,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        drvs.mesa2,
        # drvs.muslShared,
        drvs.ncurses,
        drvs.nettleGmp,
        # drvs.networkmanager,
        drvs.networkmanagerP11Kit,
        drvs.newt,
        drvs.nftables,
        drvs.openresolv,
        drvs.openssl,
        drvs.pango,
        drvs.pcre2,
        drvs.perl,
        drvs.pixman,
        drvs.polkit,
        drvs.readline,
        drvs.sharedMimeInfo,
        drvs.slang,
        drvs.spirvLlvmTranslator,
        drvs.spirvTools,
        drvs.utilLinux,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.zlibNg,
      ]
      @ (
        if distro.elogind then
          [
            # drvs.elogindNm,
            # drvs.libpam,
            # drvs.libcap,
          ]
        else
          []
      ),
  }
}
