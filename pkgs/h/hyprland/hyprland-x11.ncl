{
  lib,

  hyprland,
  xcbRenderutil,
  libxfont2,
  libfontenc,
  libxcvt,
  libxshmfence,
  xwayland,
  libxkbfile,
  openssl,
  xcbUtilWm,
  xcbUtilErrors,
  libxext,
  libxf86vm,
  libxrandr,
  mesa2,

  hyprlandX11 | lib.MesonPackage = (
    hyprland
    & {
      options = {
        glx = true,
      },
      biDrvs | priority 1 =
        hyprland.biDrvs
        @ lib.biMap (
          [
            xcbRenderutil,
            libxfont2,
            libfontenc,
            libxcvt,
            libxshmfence,
            xwayland,
            libxkbfile,
            openssl,
            xcbUtilWm,
            xcbUtilErrors,
          ]
          @ (
            if options.glx then
              [
                libxext,
                libxf86vm,
                libxrandr,
              ]
            else
              [
                mesa2
              ]
          )
        ),

      extraMesonArgs | priority 1 = [
        "-Dxwayland=enabled",
        "-Dtracy_enable=false",
        "-Dhyprpm=disabled",
        # "-Dlegacy_renderer=enabled",
      ],
    }
  )
}
