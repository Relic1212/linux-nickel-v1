{
  lib,
  drvs,
  hyprlandHyprexpo | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/colonelpanic8/hyprexpo/archive/d2786e7c21f412e0f60cc27d6763e9939ef284b0.tar.gz",
      sha256sum = "39b99ae8009c5033204c6979ca75d084c8384e1c0579b29ef88f19de063333e7",
    },
    eofPatches = [
      {
        patch = import "hyprland-hyprexpo.patch" as 'Text
      },
    ],
    preConfigurePhase = [
      "sed -i 's|#define private   public||g' ${SRC}/overview.cpp",
      "sed -i 's|#undef private||g' ${SRC}/overview.cpp",
      "sed -i 's|shared_module|library|g' ${SRC}/meson.build",
    ],
    postInstallPhase =
      let s = "hyprexpo", prefix = "hyprexpo" in
      [
        "objcopy --redefine-sym pluginAPIVersion=%{prefix}_pluginAPIVersion ${DEST}/usr/lib/lib%{s}.a",
        "objcopy --redefine-sym pluginExit=%{prefix}_pluginExit ${DEST}/usr/lib/lib%{s}.a",
        "objcopy --redefine-sym pluginInit=%{prefix}_pluginInit ${DEST}/usr/lib/lib%{s}.a",
      ],
    options.glx = false,
    llvmProvider = drvs.llvmFull,

    pDrvs = (
      if options.glx then
        [
          drvs.hyprlandX11,
        ]
      else
        [
          drvs.hyprland,
        ]
    ),
  }
}
