{
  lib,
  drvs,
  nickelLang | lib.CargoPackage
    =
      let j = import "./nickel-lang/nickel-lang-crates.json"
      in
      let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
      in

      {
        singleSource = {
          uri = "https://github.com/tweag/nickel/archive/refs/tags/1.9.0.tar.gz",
          sha256sum = "c5c0000e6b1618921c1ce23dc90eefb482bdfe9f9716d4ef5cf24a3b99ec4c7d"
        },
        # release = false,
        crates = _crates,

        biDrvs = [
          drvs.pythonFull,
        ],
        target,
        installPhase = [
          "install -d -m0755 ${DEST}/usr/bin",
          "install -m0755 target/%{target}/release/nickel ${DEST}/usr/bin",
          "install -m0755 target/%{target}/release/nls ${DEST}/usr/bin",
        ]
      }
}
