{
  lib,
  drvs,
  qemu | lib.AutotoolsPackage = {
    # debug = true,
    singleSource = {
      # uri = "https://download.qemu.org/qemu-10.1.0.tar.xz",
      # sha256sum = "e0517349b50ca73ebec2fa85b06050d5c463ca65c738833bd8fc1f15f180be51",

      # uri = "https://download.qemu.org/qemu-10.1.3.tar.xz",
      # sha256sum = "fbaa7a0d7a9a1deb5695b125916746ec28fe0de6275d4454f3e3bbaf8b339b53",

      # uri = "https://download.qemu.org/qemu-7.2.22.tar.xz",
      # sha256sum = "c74b398c1950526686cb7784e23bd8945ef138b0e6541ba0495015aad3ac9532",

      # uri = "https://download.qemu.org/qemu-10.2.4.tar.xz",
      # sha256sum = "821b545b92f165e57dddccac5077d76d4d436a226595b8813ad59306bbfd0746",

      uri = "https://download.qemu.org/qemu-11.0.3.tar.xz",
      sha256sum = "da5fcffc32762820568b828ed430a728864d34d50b6d2f30358597760cbb0523",
    },

    configureFlags = [
      "--prefix=/usr",
      "--static",
      "--target-list=x86_64-softmmu",
      "--enable-slirp",
      "--enable-opengl",
      "--enable-virglrenderer",
      "--enable-curses",
      "--enable-kvm",
      "--enable-sdl",
      "--disable-plugins",
      "--disable-modules",
      "--disable-download",
      # "--disable-tcg",
      "--enable-tcg",
      "--enable-spice",
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
        "$(pkg-config --static --libs egl gl gtk+-3.0)",
        "/tmp/workdir/src/symbols.o",
        "/tmp/workdir/src/gl_draw_buffer.o",
        "-Wl,--error-limit=0",
      ],

      EXTRA_CPPFLAGS = [
        "-Dmodule_load=qemu__module_load",
      ],
      EXTRA_CFLAGS = EXTRA_CPPFLAGS,
    },
    preConfigurePhase =
      [
        "echo '%{import "qemu_both_dlopen.c" as 'Text}' > ${SRC}/qemu_symbols.c",
        lib.functions.writeFile "${SRC}/gl_draw_buffer.c" (import "gl_draw_buffer.c" as 'Text),
        "${CC} ${CFLAGS} -c ${SRC}/qemu_symbols.c -o ${SRC}/symbols.o",
        "${CC} ${CFLAGS} -Werror -c ${SRC}/gl_draw_buffer.c -o ${SRC}/gl_draw_buffer.o",
        m%"sed -i 's|"wheel" = { accepted = ">=0.34.2" }|# "wheel" = {}|g' ${SRC}/pythondeps.toml"%,
        m%"sed -i "s@err = pthread_attr_init(\&attr);@ err = pthread_attr_init(\&attr);\nif (err) { error_exit(err, __func__); }\nerr = pthread_attr_setstacksize(\&attr, 8 * 1024 * 1024);@g" $SRC/util/qemu-thread-posix.c"%,
      ]
      @ (
        if (true) then
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
      )
      @ [
        # "rm -rf ${SRC}/tests",
        m%"sed -i "s@subdir('tests/qtest/libqos')@@g" ${SRC}/meson.build"%,
        m%"sed -i "s@subdir('tests/qtest/fuzz')@@g" ${SRC}/meson.build"%,
        m%"sed -i "s@subdir('tests')@@g" ${SRC}/meson.build"%,
      ],
    # muslProvider = drvs.muslBothWeakDl,
    muslProvider = drvs.muslBothRenamedDl,
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.pkgconf,
      drvs.samurai,
      drvs.pythonDynamic,
      drvs.bash,
      drvs.glSymlink,
      drvs.pythonSetuptools,
    ],
    pDrvs = [
      # drvs.gtk3,
      # drvs.gtk4,
      drvs.virglrenderer,
      drvs.libslirp,
      drvs.libfdt,
      drvs.vte,
      # drvs.utilLinux,
      # drvs.libusb,
      drvs.sdl2,
      # drvs.ncurses,
      drvs.spiceServer,
      drvs.bzip2,
      drvs.zstd,
      # drvs.keyutils,
      drvs.fuse,
      drvs.pipewire,
      drvs.usbredir,
    ]
  }
}
