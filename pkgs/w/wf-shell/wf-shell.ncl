{
  lib,
  drvs,
  wfShell | lib.MesonPackage = {
    enableParallel = false,
    singleSource = {
      uri = "https://github.com/WayfireWM/wf-shell/archive/refs/tags/v0.11.0.tar.gz",
      sha256sum = "328b1a01c5fc63ebc6fa79152bafdcd2e1525c8bb3caf5b49361ff2792dd57f4",
    },

    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://github.com/WayfireWM/wf-json/archive/70039e13cdeaebd8ec498ed30bf5ab91c2e313ec.tar.gz",
          sha256sum = "749d9f649f82570d860c0742c11ff83ff1b108ca7a8ec02c5c3e5f439084fafa"
        },
        dest = "subprojects/wf-json"
      },
    ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        # "-Wl,--allow-multiple-definition",
        "-lc++",
        "/tmp/workdir/src/dlopen.o",
        "$(pkg-config --static --libs gtk4-layer-shell-0)",
      ],
    },
    extraMesonArgs = [
      "-Dwayland-logout=false",
      "-Dvolume-widget=disabled",
    ],

    preConfigurePhase = [
      # https://github.com/WayfireWM/wf-shell/commit/e248716a804d68f7aa3465e50347023cd56edbbf
      m%"sed -i 's@switch (hide_animation)@switch (hide_animation.value())@g' ${SRC}/src/locker/timedrevealer.cpp"%,
      # "mv ${SRC}/src/panel/meson.build /tmp/f",
      # "head -n89 /tmp/f > ${SRC}/src/panel/meson.build",
      lib.functions.writeFile "${SRC}/dlopen.c" "%{import "../../g/gtk4-layer-shell/gtk4_layer_shell_dlopen.c" as 'Text}",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
    ],

    llvmProvider = drvs.llvmFull,
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      #drvs.waylandWeaksyms2,
    ],
    neverInclude = [
      drvs.cairo,
      drvs.libxkbcommon,
      drvs.wayland,
      # wl_proxy_marshal_array_flagsdrvs.waylandGtk4LayerShell,
    ],
    pDrvs = [
      drvs.wayfire,
      drvs.gtkmm4,
      drvs.gtk4LayerShell,
      drvs.dbusmenuGtk,
      drvs.libxkbcommonX11,
      # drvs.openssl,
      drvs.pipewire,
      drvs.pulseaudio17,
      # drvs.waylandGtk4LayerShell,
    ],
  }
}
