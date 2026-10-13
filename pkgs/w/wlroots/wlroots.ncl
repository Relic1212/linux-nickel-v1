{
  lib,
  drvs,

  wlroots20 | lib.MesonPackage = {
    singleSource | priority 1 = {
      uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.20.2/wlroots-0.20.2.tar.bz2",
      sha256sum = "20c37b521dc3054b6e9627b79bdd45fc716db9ebc58bdf97e57e84d04b04610f",
    },

    options = {
      xwayland | default = false,
    },
    extraMesonArgs = [
      "-Dxwayland=%{ if options.xwayland then "enabled" else "disabled" }",
      "-Dbackends=drm,libinput%{if options.xwayland then ",x11" else ""}",
      "-Dwlroots:color-management=enabled",
      "-Drenderers=gles2",
      "-Dexamples=false",
      "-Drenderers=gles2",
      # "-Dcolor-management=true",
      # "-Dcolor-management=disabled",
    ],

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.seatd,
      drvs.mesa2,
      drvs.libxkbcommon,
      drvs.pixman,
      # drvs.eudev,
      drvs.hwdata,
      drvs.libdisplayinfo,
      drvs.libinput,
    ],
  },

  wlroots19 | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.19.2/wlroots-0.19.2.tar.bz2",
      sha256sum = "804bd3eab10f03556628c4e977351b0b1b17bc34084342dfaff5086c54ce1fa0",
    },
    extraMesonArgs = [
      "-Dxwayland=%{ if options.xwayland then "enabled" else "disabled" }",
      "-Dbackends=drm,libinput%{if options.xwayland then ",x11" else ""}",
      "-Dwlroots:color-management=enabled",
      "-Drenderers=gles2",
      "-Dexamples=false",
      "-Drenderers=gles2",
      #   "-Dcolor-management=disabled",
    ],

    options = {
      xwayland | default = false,
    },

    postInstallPhase =
      let symbols = [
        "matrix_projection",
        "buffer_is_opaque",
        "output_pending_resolution",
      ]
      in
      std.array.map (fun x => "objcopy -W " ++ x ++ " ${DEST}/usr/lib/libwlroots-0.19.a") symbols,

    llvmProvider = drvs.llvmFull,

    pDrvs = [
      drvs.seatd,
      drvs.mesa2,
      drvs.libxkbcommon,
      drvs.pixman,
      # drvs.eudev,
      drvs.hwdata,
      drvs.libdisplayinfo,
      drvs.libinput,
    ],
  },
  wlroots19xwayland =
    wlroots19
    & {
      options.xwayland = true,
    }
}
