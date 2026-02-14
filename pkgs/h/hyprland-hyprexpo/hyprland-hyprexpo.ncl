{
  lib,
  drvs,
  hyprlandHyprspace | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/KZDKM/Hyprspace/archive/0467be86b18cfc324fab04afbd40fe9ef80f7fa9.tar.gz",
      sha256sum = "673de5cab331db143f0705f680bdbee67e644c08ce10320171184a17b62a511c"
    },
    patches = [
      {
        file = "hyprland-hyprexpo.patch",
        sha256sum = "3cc6b776092cc20041b56841a75200ec300cd3db4421bdb0955fcecb821a2bcb"
      },
    ],
    options = {
      glx | default = false,
    },
    # preConfigurePhase = [
    #   "sed -i 's|system_clock|steady_clock|g' ${SRC}/src/Overview.hpp",
    # ],
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
