{
  lib,
  drvs,
  uutilsProcps | lib.CargoPackage
    =
      let j = import "./uutils-procps-crates.json"
      in
      let _crates = lib.functions.filterCrates j
      in
      {
        singleSource = {
          uri = "https://github.com/uutils/procps/archive/2c4a5dda37b4e3d8e183dcde2f6690b159fcef82.zip",
          sha256sum = "b626a27882463740f3f751b39a4c7149502055d216265b0560d08d375de94d30"
        },

        patches = [
          {
            file = "0001-no-utmpx.patch",
            sha256sum = "f6158ce2f26e598ff4e43a950ff40f9a7e28d2729b0fc7519ef3ecc197e2838a"
          }
        ],

        crates = _crates,

        buildPhase =
          [
            m%"
            for f in $(find ${SRC} -type f -name '*.toml');do
              sed -i \
                's@"utmpx"@@g' \
                "${f}"
            done
            "%,
            m%"
            for f in $(find ${SRC} -type f -name '*.rs');do
              sed -i \
                's@feature = "utmpx"@@g' \
                "${f}"
            done
            "%,
          ]
          @ lib.CargoPackage.buildPhase,
      },

  uutilsProcpsSymlinks | lib.Package
    =
      let bins = [
        "free",
        "pgrep",
        "pidof",
        "pidwait",
        "pmap",
        "ps",
        "pwdx",
        "slabtop",
        "snice",
        "top",
        "w",
        "watch"
      ]
      in
      {
        installPhase =
          [
            "install -d -m0755 ${DEST}/usr/bin",
            "cd ${DEST}/usr/bin",
          ]
          @ (
            std.array.map
              (fun bin => "ln -s /usr/bin/procps ${DEST}/usr/bin/%{bin}")
              bins
          ),
      }
}
