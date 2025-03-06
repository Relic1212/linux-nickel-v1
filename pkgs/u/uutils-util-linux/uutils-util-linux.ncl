{
  lib,
  drvs,
  uutilsUtilLinux | lib.CargoPackage =
    let j = import "./uutils-util-linux-crates.json"
    in
    let _crates = lib.functions.filterCrates j
    in
    {

      singleSource = {
        uri = "https://github.com/uutils/util-linux/archive/81afa8a7bb849f81d397b228b015b8ba4d0f271a.zip",
        sha256sum = "8e35c03dfc0fc6887e0d704d93fc35ed7c6b71a1a52d1d2e06c943e5c7ee4d82"
      },
      crates = _crates,
      # lockfileImport | priority 1 = (import "./Cargo.lock" as 'Toml),
      # crates = lib.functions.importCargoLock (import "./Cargo.lock" as 'Toml),
      # extraCargoFlags =[
      #   "--no-default-features",
      #   "--features mountpoint,lscpu,lsmem,ctrlaltdel,rev,setsid",
      # ],

      # patches = [
      #   {
      #     sha256sum = "3d23e5dd54b08d7cee6a84d5c2d88eb2fc46796dac184e5bdc9c6dce4dcf988b",
      #     file = "0001-no-last.patch"
      #   },
      # ],
      preConfigurePhase = [
        m%"sed -i 's@"last",@@g' ${SRC}/Cargo.toml"%,

        # # m%"sed -i 's@\["utmpx"\]@\[\]@g' ${SRC}/src/uu/last/Cargo.toml"%,
      ]
    }
}
& (import "../uutils-procps/uutils-procps.ncl")
& (import "../uutils-diffutils/uutils-diffutils.ncl")
& (import "../uutils-findutils/uutils-findutils.ncl")
& (import "../uutils-login/uutils-login.ncl")
