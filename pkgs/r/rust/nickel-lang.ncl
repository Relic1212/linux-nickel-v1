{
  lib,
  drvs,
  nickelLang | lib.CargoPackage =
    let j = import "./nickel-lang/nickel-lang-crates.json"
    in
    let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
    in

    {
      singleSource = {

        uri = "https://github.com/tweag/nickel/archive/refs/tags/1.15.1.tar.gz",
        sha256sum = "93528c7b763f082767f4f6069b74f72345880ee6f5175f85ea8297d96d8797c3",
      },
      crates = _crates,

      extraCargoFlags = [
        "--verbose",
      ],

      biDrvs = [
        drvs.pythonFull,
        drvs.mimalloc & { priority = 1 },
      ],
      target,
      installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/nickel ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/nls ${DEST}/usr/bin",
      ]
    },
}
