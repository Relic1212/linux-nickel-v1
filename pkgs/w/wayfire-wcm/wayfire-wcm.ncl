{
  lib,
  drvs,
  wayfireWcm | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/WayfireWM/wcm/archive/refs/tags/v0.11.0.tar.gz",
      sha256sum = "239aaa77d53b0105cf26cfcd669db46ffacd0df822ba0b6a5c79e624ac526f86",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
      EXTRA_LDFLAGS = [
        #"-Wl,--allow-multiple-definition",
        #"-lc++",
        "/tmp/workdir/src/dlopen.o",
        #"$(pkg-config --static --libs gtk4-layer-shell-0)",
      ],
    },

    extraMesonArgs = [
      "-Dwf_shell=enabled",
      # "-Dwf_shell=disabled",
    ],

    preConfigurePhase = [
      # lib.functions.writeFile "${SRC}/dlopen.c" "%{import "../../g/gtk4-layer-shell/gtk4_layer_shell_dlopen.c" as 'Text}",
      "dl-func > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -Werror -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
      # m%"sed -i 's@gtkmm-3.0@gtkmm-4.0@g' ${SRC}/src/meson.build"%,
      m%"sed -i 's@wcm.svg@wcm.png@g' ${SRC}/src/wcm.cpp"%,
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.gettext,
      drvs.pythonDlFunc,
      # drvs.gdkPixbufSvg,
      # drvs.glycin,
    ],
    neverInclude = [
      drvs.cairo,
      drvs.libxkbcommon,
      # drvs.wayland,
      drvs.waylandGtk4LayerShell,
      drvs.gdkPixbuf,
      # drvs.gdkPixbufFull,
    ],
    pDrvs = [
      # drvs.libseccomp,
      # drvs.eudev,
      # drvs.libinput,
      # drvs.wayfire,
      # drvs.gtkmm3,
      # drvs.libxkbcommonX11,
      drvs.fmt,
      drvs.wfShell,
      # drvs.gtkmm4,
      drvs.gtkmm3,
    ],
  },
  wayfireWcmIcons | lib.Package = {
    biDrvs = [
      drvs.imagemagick,
      drvs.wayfireWcm,
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/share/icons/hicolor/scalable/apps",
      "cd /usr/share/icons/hicolor/scalable/apps",
      m%"for f in $(ls | cut -d '.' -f1); do echo  "f=${f}"; magick convert "${f}.svg" "${DEST}/usr/share/icons/hicolor/scalable/apps/${f}.png";done"%,
    ]
  }
}
