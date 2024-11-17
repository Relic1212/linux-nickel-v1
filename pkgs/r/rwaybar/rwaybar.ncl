{
  lib,
  drvs,
  rwaybar | lib.CargoPackage
    =
      let j = import "./rwaybar-crates.json"
      in
      let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
      in

      {
        singleSource = {
          uri = "https://github.com/danieldg/rwaybar/archive/aa949294d7ad8dfc2718d716cc4fdf9308fcf3fb.zip",
          sha256sum = "65b8a208741253a530b9215fec9370f64c8d4bf6c2c393c6c62f03cb0bbde2bb"
        },
        # release = false,
        crates = _crates,
      }
}
