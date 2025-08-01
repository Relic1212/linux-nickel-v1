{
  lib,
  drvs,
  hyprlandContrib | lib.MakePackage = {
    singleSource = {
      uri = "https://github.com/hyprwm/contrib/archive/6839b23345b71db17cd408373de4f5605bf589b8.tar.gz",
      sha256sum = "00e495b341bb8d91cf1dd07b673c040deb904cd334ed702711c98a52397f9824"
    },
    buildPhase = [
      m%"
            for d in grimblast hdrop hyprprop scratchpad shellevents try_swap_workspace; do
                cd $d
                make PREFIX=${DEST}/usr
                make PREFIX=${DEST}/usr DESTDIR=${DEST} install
                cd ..
            done
            "%
    ],
    installPhase = [],
    biDrvs = [
      drvs.scdoc,
    ]
  }
}
