{
  lib,
  drvs,
  dmenuWayland | lib.MesonPackage = {
    singleSource = {
      uri = "https://github.com/nyyManni/dmenu-wayland/archive/a380201dff5bfac2dace553d7eaedb6cea6855f9.zip",
      sha256sum = "322825490f933f9b8f18cc450f5559f5a524b8aa66ef9a4cfb10ab7ebe354e9d",
    },
    biDrvs = [
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.ncurses,
      drvs.readline,
      drvs.pcre2,
      drvs.pango,
      drvs.cairo,
      drvs.libpng,
      drvs.harfbuzz,
      drvs.scdoc,
      drvs.glib,
      drvs.hwdata,
    ],
    postInstallPhase = [
      "cd ${DEST}/usr/bin",
      "ln -s dmenu-wl dmenu",
      "ln -s dmenu-wl_path dmenu_path",
      "ln -s dmenu-wl_run dmenu_run",
    ]
  }
}
