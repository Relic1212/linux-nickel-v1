{
  lib,
  drvs,
  spiceVdagent | lib.AutomakePackage = {
    singleSource = {
      uri = "https://www.spice-space.org/download/releases/spice-vdagent-0.22.0.tar.bz2",
      sha256sum = "553597a2ee3dcecd687db3fd92c6b6bb460260a53879d914ae9619ce81a8fb93",
    },
    sourceInputs = [
      {
        src = {
          # uri = "https://gitlab.freedesktop.org/spice/linux/vd_agent/-/archive/spice-vdagent-0.23.0/vd_agent-spice-vdagent-0.23.0.tar.bz2",
          # sha256sum = "40b37e6efa100536e3cd2f05306a306ac66b8152e97106ec235d448a5b6e3b85",
          uri = "https://gitlab.freedesktop.org/spice/linux/vd_agent/-/archive/f0dc2b098d7a5cb6bd317e0682851b3d9cbc2836/vd_agent-f0dc2b098d7a5cb6bd317e0682851b3d9cbc2836.tar.bz2",
          sha256sum = "91ef2a8d209630534b58aced90ba8cf40a1bc8ac518ca977b10ef8f89fe70eec",
        }
      },
      {
        src = {
          uri = "https://gitlab.freedesktop.org/spice/linux/vd_agent/-/merge_requests/57.patch",
          # 2026-08-24, 9 commits
          sha256sum = "1d34cb2cd7228317d9c42d551a185bdea643108b50903c29f62251d475758718",
        },
      },
    ],
    buildEnv = {
      EXTRA_CFLAGS = [
        # "$(pkg-config --cflags gtk+-3.0)",
      ],
      EXTRA_CPPFLAGS = EXTRA_CFLAGS,
      EXTRA_LDFLAGS = [
        "/tmp/workdir/src/dlopen.o",
      ],
    },
    extraConfigureFlags = [
      "--with-gtk4=yes",
      "--with-gtk=yes",
      "--with-session-info=systemd",
      "--with-wayland=yes",
    ],

    preConfigurePhase = [
      #   m%"export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig""%,
      "echo '%{import "spice_vdagent_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      "LIBSYSTEMD_LOGIN_LIBS=\"$(pkg-config --libs --static libelogind)\"",
      "export LIBSYSTEMD_LOGIN_LIBS",
      "cd ${SRC}",
      "patch -p1 < 57.patch",
      "cd ${BUILDDIR}",
    ],
    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    # allowDubplicateBuldInputs = true,

    biDrvs = [
      # drvs.pkgconfMeson,
      drvs.gtk3X11,
      llvmProvider, #  FIXME: AutomakePackage
    ],
    neverInclude = [
      drvs.gtk3,
      drvs.llvm, #  FIXME: AutomakePackage
    ],
    pDrvs = [
      drvs.gtk4X11,
      #   drvs.libxrandr,
      #   drvs.libxinerama,
      # drvs.libx11,
      #   drvs.libxfixes,
      drvs.spiceProtocol,
      drvs.alsaLibs,
      #   drvs.libxi,
      #   drvs.cairoXlib,
      # drvs.libxcursor,
      drvs.elogindWithPolkit,
      drvs.systemdElogindSymlink,
    ],
  },
  systemdElogindSymlink | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      "cd ${DEST}/usr/lib/pkgconfig",
      "ln -s libelogind.pc libsystemd-login.pc",
      "ln -s libelogind.pc libsystemd.pc",
    ]
  }
}
