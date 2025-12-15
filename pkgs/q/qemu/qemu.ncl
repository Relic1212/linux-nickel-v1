{
  lib,
  drvs,
  qemu | lib.AutotoolsPackage = {
    singleSource = {
      # uri = "https://download.qemu.org/qemu-10.1.0.tar.xz",
      # sha256sum = "e0517349b50ca73ebec2fa85b06050d5c463ca65c738833bd8fc1f15f180be51",

      # uri = "https://download.qemu.org/qemu-10.1.3.tar.xz",
      # sha256sum = "fbaa7a0d7a9a1deb5695b125916746ec28fe0de6275d4454f3e3bbaf8b339b53",

      uri = "https://download.qemu.org/qemu-7.2.22.tar.xz",
      sha256sum = "c74b398c1950526686cb7784e23bd8945ef138b0e6541ba0495015aad3ac9532",
    },

    configureFlags = [
      "--prefix=/usr",
      "--static",
      "--target-list=x86_64-softmmu",
      "--enable-slirp",
      "--enable-opengl",
      "--enable-virglrenderer",
    ],

    buildEnv.EXTRA_LDFLAGS = [
      "-lc++",
      "$(pkg-config --static --libs egl gl gtk+-3.0)",
      "/tmp/workdir/src/symbols.o",
      "-Wl,--error-limit=0",
    ],
    preConfigurePhase =
      [
        "echo '%{import "qemu_dlopen_glx.c" as 'Text}' > ${SRC}/qemu_symbols.c",
        "${CC} ${CFLAGS} -c ${SRC}/qemu_symbols.c -o ${SRC}/symbols.o",
      ]
      @ (
        if false then
          (
            std.array.map
              (fun s => "sed -i 's|object_property_get_type|qemu_private__object_property_get_type|g' ${SRC}/%{s}"
              )
              [
                "system/qdev-monitor.c",
                "qom/object.c",
                "include/qom/object.h",
              ]
          )
        else
          (
            (
              std.array.map
                (fun s => "sed -i 's|lseek64|lseek|g' ${SRC}/%{s}"
                )
                [
                  "linux-user/syscall.c",
                  "contrib/vhost-user-blk/vhost-user-blk.c",
                  "roms/openbios/arch/unix/unix.c",
                  "roms/skiboot/external/xscom-utils/xscom.c",
                ]
            )
            @ (
              std.array.map
                (fun s => "sed -i 's|off64_t|off_t|g' ${SRC}/%{s}"
                )
                [
                  "block/file-win32.c",
                  "contrib/vhost-user-blk/vhost-user-blk.c",
                  "linux-user/syscall.c",
                ]
            )
            @ [
              m%"sed -i "s|#include <sys/ioctl.h>|#include <sys/ioctl.h>\n#include <basename.h>|g" ${SRC}/hw/vfio/pci.c"%
            ]
          )
      ),
    muslProvider = drvs.muslBothWeakDl,
    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        drvs.pkgconf,
        drvs.samurai,
        drvs.pythonDynamic,
      ]
      @ [
        drvs.bash,
        # (drvs.muslShared & { priority = -1 }),
        drvs.libslirp,
        drvs.appstream,
        drvs.atSpi2Core,
        drvs.cairo,
        drvs.cairoGobject,
        drvs.curl,
        drvs.eudev,
        drvs.expat,
        drvs.fastFloat,
        drvs.feedbackd,
        drvs.fontconfig,
        drvs.freetype,
        drvs.fribidi,
        drvs.gdkPixbufFull,
        drvs.gettext,
        drvs.glib,
        drvs.gnomeDesktop,
        drvs.gperf,
        drvs.graphene,
        drvs.gsettingsDesktopSchemas,
        drvs.gsound,
        drvs.gtk3,
        drvs.gtk4,
        drvs.gudev,
        drvs.harfbuzzFull,
        drvs.hwdata,
        drvs.isoCodes,
        drvs.jansson,
        drvs.jsonGlib,
        drvs.kmod,
        drvs.libbsd,
        drvs.libcanberra,
        drvs.libcap,
        drvs.libdrm,
        drvs.libelf,
        drvs.libepoxy,
        drvs.libfdt,
        drvs.libffi,
        drvs.libgtop,
        drvs.libjpegTurbo,
        drvs.libmd,
        drvs.libogg,
        drvs.libpciaccess,
        drvs.libpng,
        drvs.libportal,
        drvs.libpsl,
        drvs.libseccomp,
        drvs.libtiff,
        drvs.libtool,
        drvs.libusb,
        drvs.libvorbis,
        drvs.libxkbcommon,
        drvs.libxml2,
        drvs.libxmlb,
        drvs.libyaml,
        drvs.linuxHeaders,
        drvs.llvmConfigStatic,
        drvs.lz4,
        drvs.ncurses,
        drvs.openssl,
        drvs.pango,
        drvs.pcre2,
        drvs.pixman,
        drvs.readline,
        drvs.sassc,
        drvs.spirvLlvmTranslator,
        drvs.spirvTools,
        drvs.utilLinux,
        drvs.vala,
        drvs.vte,
        drvs.virglrenderer,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.xkeyboardConfig,
        drvs.xz,
        drvs.zlibNg,
        drvs.zstd,
        # drvs.mesa2,
        drvs.mesaGlxEpoxy,
        drvs.libxcursor,
        drvs.xorgMacros,
        drvs.xorgproto,
        drvs.xtrans,
        drvs.libxcb,
        drvs.xcbProto,
        drvs.libxau,
        drvs.libx11,
        drvs.libxrender,
        drvs.libxfixes,
        drvs.xcbRenderutil,
        drvs.libxfont2,
        drvs.libfontenc,
        drvs.libxcvt,
        drvs.libxshmfence,
        # drvs.xwayland,
        drvs.libxkbfile,
        drvs.xcbUtilWm,
        drvs.xcbUtilErrors,
        drvs.libxext,
        drvs.libxf86vm,
        drvs.libxrandr,
        drvs.pythonSetuptools,
        drvs.basenameCompat,
      ],
  }
}
