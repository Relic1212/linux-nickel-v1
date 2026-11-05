{
  lib,
  drvs,
  wayfire,
  wayfirePluginsExtra | lib.MesonPackage = {
    debug = wayfire.debug,
    singleSource = {
      uri = "https://github.com/WayfireWM/wayfire-plugins-extra/archive/refs/tags/v0.11.2.tar.gz",
      sha256sum = "def0072efbd8ccd88588296c72df27241caf3dee0007d2535d26770a08f0aca2",
    },
    eofPatches = [
      {
        patch = import "all.patch" as 'Text,
      },
    ],

    extraMesonArgs = [
      # "-Dwayfire_shadows=true",
    ],

    preConfigurePhase = [
      m%"sed -i 's@shared_module@library@g' ${SRC}/src/meson.build ${SRC}/src/extra-animations/meson.build"%,
    ],

    postInstallPhase = (
      std.array.map
        (fun arg => let ref = "llvm-objcopy --redefine-sym", p = "${DEST}/usr/lib/wayfire/lib%{arg}.a", arg2 = std.string.replace "-" "_" arg in "%{ref} getWayfireVersion=%{arg2}__getWayfireVersion %{p}\n%{ref} newInstance=%{arg2}__newInstance %{p}")
        [
          "annotate",
          "bench",
          "crosshair",
          "extra-animations",
          "fisheye",
          "focus-change",
          "focus-steal-prevent",
          "follow-focus",
          "force-fullscreen",
          "ghost",
          "hide-cursor",
          "join-views",
          "keycolor",
          "mag",
          "obs",
          "pin-view",
          "showrepaint",
          "showtouch",
          "view-shot",
          "water",
          "winzoom",
          "workspace-names",
        ]
    ),

    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.gettext,
    ],
    pDrvs = [
      drvs.wayfire,
      drvs.boost,
    ]
  }
}
