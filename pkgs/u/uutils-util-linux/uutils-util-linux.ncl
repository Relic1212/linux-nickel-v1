{
  lib,
  drvs,
  uutilsUtilLinux | lib.CargoPackage
    =
      let j = import "./uutils-util-linux-crates.json"
      in
      let _crates = lib.functions.filterCrates j
      in
      let _c | lib.CargoPackage
        = {
          singleSource = {
            uri = "https://github.com/uutils/util-linux/archive/a36a495bda52402fe6d270e2e0c238aaefe0b46e.zip",
            sha256sum = "a97742769e934b5c74ff4eda3b98aed6f1ba94068dbb708634851eef93934fa0"
          },
          crates = _crates,
          # extraCargoFlags =[
          #   "--no-default-features",
          #   "--features mountpoint,lscpu,lsmem,ctrlaltdel,rev,setsid",
          # ],
          
          patches = [
            {
              sha256sum = "3d23e5dd54b08d7cee6a84d5c2d88eb2fc46796dac184e5bdc9c6dce4dcf988b",
              file = "0001-no-last.patch"
            },
          ]
        }
        in
      _c
}
& (import "../uutils-procps/uutils-procps.ncl")
& (import "../uutils-diffutils/uutils-diffutils.ncl")
& (import "../uutils-findutils/uutils-findutils.ncl")
& (import "../uutils-login/uutils-login.ncl")
