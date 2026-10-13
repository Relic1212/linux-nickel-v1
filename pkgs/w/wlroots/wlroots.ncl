{
  lib,
  drvs,

  wlroots20 | lib.MesonPackage =
    wlroots19
    & {
      singleSource | priority 1 = {
        uri = "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/0.20.0/wlroots-0.20.0.tar.bz2",
        sha256sum = "acb7714cf3853cf6f8f500af35fa5df140fbad2fe9403e978609cf9d0b50b3b4",
      },
      preConfigurePhase = [
        m%"sed -i 's|129|128|g' ${SRC}/meson.build"%, # libdrm
        m%"sed -i 's|0.46.0|0.43.0|g' ${SRC}/render/pixman/meson.build"%, # pixman
      ],
      postInstallPhase | priority 1 = [
        "(cd ${DEST}/usr/include && ln -s wlroots-0.20/wlr wlr)",
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

    propagatedBuildInputs = [
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
