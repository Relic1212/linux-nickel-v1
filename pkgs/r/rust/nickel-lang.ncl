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

        uri = "https://github.com/tweag/nickel/archive/refs/tags/1.14.0.tar.gz",
        sha256sum = "7bd9d368f780d506dc63895b7b033ec8b5a98507c7738c2cc263ee5be87cdf67",
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
