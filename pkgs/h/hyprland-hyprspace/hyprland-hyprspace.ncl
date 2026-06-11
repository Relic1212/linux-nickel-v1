{
  lib,
  drvs,
  hyprland,
  hyprlandHyprspace | lib.MesonPackage =
    let patches = [
      # {
      #   src = {
      #     uri = "https://github.com/KZDKM/Hyprspace/commit/5f12222eeab6cb3a0ff1237f7444eb0b8ca00351.patch",
      #     sha256sum = "8f04ae2328548bc28c229801c6ac8366f7111f11e38a38bc18c8a90d7e03a2df"
      #   }
      # },
      # {
      #   src = {
      #     uri = "https://github.com/KZDKM/Hyprspace/commit/a9d7685ef610d5a45c7c4f9f974bdf78443c9829.patch",
      #     sha256sum = "28fd761a35cbe10dc77c1e0b2168f642af936bb0e5e573a36b3d4a15a44049c1"
      #   },
      # },
      # {
      #   src = {
      #     uri = "https://github.com/KZDKM/Hyprspace/commit/2ca4f1a47cf2dc569e6e7034e53c4cd9b25e36a8.patch",
      #     sha256sum = "7785df0d84283ac4d7a2392d5f2a1bd3270e986071d55e884ea81f02b5e13722",
      #   },
      # },
      # {
      #   src = {
      #     uri = "https://github.com/KZDKM/Hyprspace/commit/bf2ef21007e8963fcb0016ae26b6b21704946f80.patch",
      #     sha256sum = "1d28dfdc85f1bed5024ecc0d913510f26f8d44da9f773abd735f230521343bde",
      #   },
      # },
    ]
    in
    {
      debug = hyprland.debug,
      singleSource = {
        # uri = "https://github.com/KZDKM/Hyprspace/archive/c109256f5a79a8694acd6176971c4a273d32264c.tar.gz",
        # sha256sum = "6e50f6055143593b0345bf032a9227db92a1370d353bc943cc84c3d63c48d1a6",

        uri = "https://github.com/0xl30/Hyprspace/archive/74213c87be6064ce14f9b1560121c270462f33af.tar.gz",
        sha256sum = "1fd20d53f1f65908d84e30e3c09a9578c597afa2bdb902a9a925dd51114918f5",
      },
      sourceInputs =
        [
          { src = singleSource, },
        ]
        @ patches,
      # eofPatches = [
      #   {
      #     patch = import "hyprland-hyprexpo.patch" as 'Text,
      #   },
      # ],
      options = {
        glx | default = false,
      },
      # debug = true,
      preConfigurePhase =
        (
          std.array.map
            (fun sp =>
              "(cd ${SRC} && patch -p1 < %{ std.string.split "/" sp.src.uri|>std.array.last })"
            )
            patches
        )
        @ [
          # "(cd ${SRC} && patch -p1 < 5f12222eeab6cb3a0ff1237f7444eb0b8ca00351.patch)",
          # "(cd ${SRC} && patch -p1 < a9d7685ef610d5a45c7c4f9f974bdf78443c9829.patch)",
          # "(cd ${SRC} && patch -p1 < 2ca4f1a47cf2dc569e6e7034e53c4cd9b25e36a8.patch)",
          "sed -i 's|shared_module|library|g' ${SRC}/meson.build",
          "sed -i 's|system_clock|steady_clock|g' ${SRC}/src/Overview.hpp",
        ],
      postInstallPhase =
        let s = "Hyprspace" in
        let prefix = std.string.replace "-" "_" s in
        [
          "objcopy --redefine-sym pluginAPIVersion=%{prefix}_pluginAPIVersion ${DEST}/usr/lib/lib%{s}.a",
          "objcopy --redefine-sym pluginExit=%{prefix}_pluginExit ${DEST}/usr/lib/lib%{s}.a",
          "objcopy --redefine-sym pluginInit=%{prefix}_pluginInit ${DEST}/usr/lib/lib%{s}.a"
        ],
      llvmProvider = drvs.llvmFull,

      biDrvs =
        [
          drvs.lua,
          drvs.glslang,
          drvs.expat,
          drvs.jsonC,
          drvs.pcre2,
          drvs.wayland,
          drvs.waylandProtocols,
          drvs.libelf,
          drvs.libpciaccess,
          drvs.libdrm,
          drvs.libxkbcommon,
          drvs.pixman,
          drvs.eudev,
          drvs.seatd,
          drvs.libdisplayinfo,
          drvs.libinput,
          drvs.libffi,
          drvs.libevdev,
          drvs.mtdev,
          drvs.pango,
          drvs.cairo,
          drvs.libpng,
          drvs.freetype,
          drvs.fontconfig,
          drvs.zlibNg,
          drvs.harfbuzz,
          drvs.glib,
          drvs.hwdata,
          drvs.linuxHeaders,
          drvs.hyprwaylandScanner,
          drvs.hyprutils,
          drvs.hyprlang,
          drvs.hyprcursor,
          #  drvs.cmake,
          drvs.tomlplusplus,
          drvs.utilLinux,
          ###############################################################
          drvs.hyprlandProtocols,
          drvs.udis86,
          drvs.hyprgraphics,
          drvs.re2,
          drvs.abseilCpp,
          ###############################################################
          drvs.libxcursor,
          drvs.xorgMacros,
          drvs.xorgproto,
          drvs.xtrans,
          drvs.libxcb,
          drvs.xcbProto,
          drvs.libxau,
          drvs.libx11,
          drvs.libxrender,
          drvs.libxfixes,
          ###################################################
          drvs.git,
          drvs.libzip,
          drvs.spirvTools,
          drvs.glaze,
          drvs.cmake,
          drvs.fribidi,
        ]
        @ (
          if options.glx then
            [
              drvs.aquamarineGlx,
              drvs.mesaGlx,
              drvs.hyprlandX11,
            ]
          else
            [
              drvs.aquamarine,
              drvs.mesa2,
              drvs.hyprland,
            ]
        ),
    }
}
