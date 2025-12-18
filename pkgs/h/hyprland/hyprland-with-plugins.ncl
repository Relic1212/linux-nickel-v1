{
  lib,
  drvs,
  hyprland,
  hyprlandWithPlugins | lib.MesonPackage =
    hyprland
    & {
      #   buildEnv = {
      #     EXTRA_LDFLAGS | priority 1 =
      #       hyprland.buildEnv.EXTRA_LDFLAGS
      #       @ [
      #         "-lborders-plus-plus",
      #         "-lhyprbars",
      #         "-lhyprexpo",
      #         "-lhyprfocus",
      #         "-lhyprscrolling",
      #         "-lxtra-dispatchers",
      #         "/tmp/workdir/src/dlopen.o",
      #       ],
      #   },
      patches = [
        { file = "hyprland_dlopen.patch", sha256sum = "93bd50de0751a2eae321b7dac9303640b7bd1a33b90e5d0acbc52fe1ac80403e" },
      ],
      preConfigurePhase | priority 1 =
        [
          "echo '%{ import "hyprland_dlopen.c" as 'Text }' > ${SRC}/dlopen.c",
          "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
        ]
        @ hyprland.preConfigurePhase,
      muslProvider = drvs.muslBothWeakDl,
      biDrvs | priority 1 =
        hyprland.biDrvs
        @ [
          drvs.hyprlandPlugins,
        ],
    }
}
