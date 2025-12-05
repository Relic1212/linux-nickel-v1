let qtbase_configureflags = [
  "-prefix /usr",
  "-sysconfdir /etc",
  # "-cmake-generator Ninja",
  "-static",
  "-no-shared",
  "-pkg-config",
  "-gui",
  "-widgets",
  "-no-accessibility",

  # "-opengl es2",
  "-opengl",
  "-no-egl",

  #"-gbm",
  "-libinput",
  "-xkbcommon",
  "-qpa wayland;xcb",
  "-dbus-linked",
]
in
let qtbaseCmakeExtraArgsRecorf = {
  "-DFEATURE_widgets" = "ON",
  "-DFEATURE_wayland" = "ON",
  "-DFEATURE_libinput" = "ON",
  # "-DFEATURE_opengles2"="ON",
  "-DINPUT_opengl" = "es2",
  "-DFEATURE_gui" = "ON",
  "-DFEATURE_gbm" = "ON",
  # "-DBUILD_SHARED_LIBS"="OFF",
  "-DFEATURE_openssl_linked" = "ON",
  "-DFEATURE_dbus" = "ON",

  "-DFEATURE_egl" = "ON",
  "-DCMAKE_MODULE_LINKER_FLAGS:STRING" = "\"-static --static -fuse-ld=lld -stdlib=libc++ -rtlib=compiler-rt -unwindlib=libunwind -lc++ -lglapi -ldrm $(pkg-config --libs --static dri glesv2 gbm egl)\"",

  "-DQT_QPA_DEFAULT_PLATFORM" = "wayland",

  "-DQT_QPA_PLATFORMS" = "wayland",
  "-DINSTALL_QMLDIR" = "/usr/lib/qt6/qml",
  "-DINSTALL_PLUGINSDIR" = "/usr/lib/qt6/plugins",
}
in
{
  lib,
  drvs,
  qtbase | lib.QtPackage = {
    generator = "Ninja",

    llvmProvider = drvs.llvmFull,

    biDrvs =
      [
        drvs.mesa2,
        # drvs.pkgconf,
        drvs.libelf,
        drvs.libdrm,
        drvs.zlibNg,
        drvs.pythonMako,
        drvs.pythonPackaging,
        drvs.pythonMarkupsafe,
        drvs.libpciaccess,
        drvs.libffi,
        drvs.bison,
        drvs.flex,
        drvs.wayland,
        drvs.waylandProtocols,
        drvs.linuxHeaders,
        drvs.m4,
        drvs.git,
        drvs.pyyaml,
        drvs.llvmConfigStatic,
        drvs.spirvTools,
        drvs.spirvLlvmTranslator,
        ###

        ###
        drvs.jsonC,
        drvs.pcre2,
        # drvs.libxkbcommon,
        drvs.dbusForQt,
        drvs.eudev,
        drvs.kmod,
        drvs.utilLinux,
        drvs.libinput,
        drvs.openssl,

        ### font
        drvs.fontconfig,
        drvs.freetype,
        drvs.harfbuzzFull,
        drvs.cairo,
        drvs.pixman,
        drvs.libpng,
        drvs.expat,
        drvs.glib,
        ### -font
      ]
      @ (
        if options.x11 then
          [
            drvs.libevdev,
            drvs.libx11,
            drvs.libxau,
            drvs.libxcb,
            drvs.libxcursor,
            drvs.libxfixes,
            drvs.libxkbcommonX11,
            drvs.libxrender,
            drvs.xcbProto,
            drvs.xcbRenderutil,
            drvs.xcbUtil,
            drvs.xcbUtilCursor,
            drvs.xcbUtilErrors,
            drvs.xcbUtilImage,
            drvs.xcbUtilKeysyms,
            drvs.xcbUtilWm,
            drvs.xorgMacros,
            drvs.xorgproto,
            drvs.xtrans,
          ]
        else
          [
            drvs.libxkbcommon,
          ]
      )
      @ [
        # drvs.cmake,
        # drvs.samurai,
        # drvs.pkgconf,
      ],

    preConfigurePhase = [
      # "echo 'forced rebuild'",
      m%"sed -i 's@\/bin\/pwd@\/usr\/bin\/pwd@g' ${SRC}/configure"%,
    ],
    options = {
      x11 | default = false,
    },
    cmakeExtraArgsRecord =
      qtbaseCmakeExtraArgsRecorf
      & (
        if options.x11 then
          {
            "-DFEATURE_xcb" = true,
            "-DFEATURE_xkbcommon_x11" = true,
            "-DFEATURE_system_xcb_input" = true,
            "-DCMAKE_ENABLE_FIND_PACKAGE_X11" = true,
          }
        else
          {}
      ),

    #buildPhase = [
    #  "ninja"
    #],
    #installPhase = [
    #  "DESTDIR=${DEST} ninja install"
    #],

    # buildEnv = {
    #   EXTRA_LDFLAGS = [
    #     "-lc++",
    #     "-lglapi",
    #     "-ldrm",
    #     "$(pkg-config --libs --static gbm glesv2 dri egl)",
    #   ],
    # },
  },
  qtbaseX11 =
    qtbase
    & {
      srcName = "qtbase",
      options.x11 = true,
      buildEnv = {
        EXTRA_LDFLAGS = [
          "$(pkg-config --static --libs libudev)",
          "$(pkg-config --static --libs libevdev)",
          "$(pkg-config --static --libs xcb)",
          "$(pkg-config --static --libs xcb-shm)",
          "$(pkg-config --static --libs x11-xcb)",
          "$(pkg-config --static --libs xau)",
        ]
      }
    }
}
& {
  lib,
  drvs,
  dbus,
  dbusForQt | lib.MesonPackage = (
    dbus
    & {
      postInstallPhase | priority 1 =
        dbus.postInstallPhase
        @ [
          "sed -i 's@dbus-1.0 -pthread @dbus-1.0 @g' ${DEST}/usr/lib/pkgconfig/dbus-1.pc"
        ]
    }
  )
}
& (import "qtwayland.ncl")
& (import "qtdeclarative.ncl")
& (import "qtshadertools.ncl")
& (import "qtquick3d.ncl")
& (import "qt5compat.ncl")
& (import "qt-tools.ncl")
& (import "qtsensors.ncl")
& (import "qtsvg.ncl")
& (import "QtPackage.ncl")
& (import "qtgraphicaleffects.ncl")
