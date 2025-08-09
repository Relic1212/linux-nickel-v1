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

        uri = "https://github.com/tweag/nickel/archive/refs/tags/1.12.2.tar.gz",
        sha256sum = "1161b901c238d78dfb2529fee878f37d69c4187ba10d5bd0e2723836d19f7c15"
      },
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
