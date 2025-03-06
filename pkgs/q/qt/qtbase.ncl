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
}
in
{
  lib,
  drvs,
  pkgs,
  qtbase | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/qt/qtbase/archive/refs/tags/v6.8.2.tar.gz",
      sha256sum = "9dddbb2ea3c107e20a99b816c1c6ba1483915325918936dda2c762bd73836ad9"
    },
    llvmProvider = pkgs.llvmFull,

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
        drvs.libxkbcommon,
        drvs.dbusForQt,
        drvs.eudev,
        drvs.kmod,
        drvs.utilLinux,
        drvs.libinput,
        drvs.openssl,
      ]
      @ [
        # drvs.cmake,
        # drvs.samurai,
        # drvs.pkgconf,
      ],

    preConfigurePhase = [
      m%"sed -i 's@\/bin\/pwd@\/usr\/bin\/pwd@g' ${SRC}/configure"%,
    ],
    cmakeExtraArgsRecord = qtbaseCmakeExtraArgsRecorf,

    #buildPhase = [
    #  "ninja"
    #],
    #installPhase = [
    #  "DESTDIR=${DEST} ninja install"
    #],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
        "-lglapi",
        "-ldrm",
        "$(pkg-config --libs --static gbm glesv2 dri egl)",
      ],
    },
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
