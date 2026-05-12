{
  lib,
  drvs,
  hyprlandHyprspace | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/KZDKM/Hyprspace/archive/12ddde04f8584bf7de3151e6169918e0dda9f822.tar.gz",
      sha256sum = "2f26b5417c8faa5fbd21ed9d91d06207cae2ad83210b9e6c00989c26ed42b49b"
    },
    sourceInputs = [
      { src = singleSource, },
      {
        src = {
          uri = "https://github.com/KZDKM/Hyprspace/commit/5f12222eeab6cb3a0ff1237f7444eb0b8ca00351.patch",
          sha256sum = "8f04ae2328548bc28c229801c6ac8366f7111f11e38a38bc18c8a90d7e03a2df"
        }
      },
    ],
    # eofPatches = [
    #   {
    #     patch = import "hyprland-hyprexpo.patch" as 'Text,
    #   },
    # ],
    options = {
      glx | default = false,
    },
    preConfigurePhase = [
      "(cd ${SRC} && patch -p1 < 5f12222eeab6cb3a0ff1237f7444eb0b8ca00351.patch)",
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
