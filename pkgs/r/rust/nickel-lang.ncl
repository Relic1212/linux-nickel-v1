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

        uri = "https://github.com/nickel-lang/nickel/archive/refs/tags/1.16.0.tar.gz",
        sha256sum = "32a449ebc4d463dd193eb8ce8aced5324655188095e709a9c0addb7b3ceeaec3",
      },
      crates = _crates,

      extraCargoFlags = [
        "--verbose",
        "--no-default-features",
      ],
      linkSelfContained = "no",

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
