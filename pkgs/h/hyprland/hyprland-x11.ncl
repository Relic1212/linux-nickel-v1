{
  lib,
  drvs,
  hyprland,
  hyprlandX11 | lib.CmakePackage = (
    hyprland
    & {
      options = {
        glx = true,
      },
      biDrvs | priority 1 =
        hyprland.biDrvs
        @ [
          drvs.xcbRenderutil,
          drvs.libxfont2,
          drvs.libfontenc,
          drvs.libxcvt,
          drvs.libxshmfence,
          drvs.xwayland,
          drvs.libxkbfile,
          drvs.openssl,
          drvs.xcbUtilWm,
          drvs.xcbUtilErrors,
        ]
        @ (
          if options.glx then
            [
              drvs.libxext,
              drvs.libxf86vm,
              drvs.libxrandr,
            ]
          else
            [
              drvs.mesa2
            ]
        ),

      # extraMesonArgs | priority 1 = [
      #   "-Dxwayland=enabled",
      #   "-Dtracy_enable=false",
      #   "-Dhyprpm=enabled",
      #   # "-Dlegacy_renderer=enabled",
      # ],

      cmakeExtraArgsRecord = {
        "-DNO_XWAYLAND" | priority 1 = false,
        # "-DUSE_TRACY" = false,
        # "-DNO_HYPRPM" = true,
      },
    }
  )
}
