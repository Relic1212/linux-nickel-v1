let drvUtils = import "drv.ncl"
in
let keyToName = (import "keyToName.ncl").keyToName in

let name_pkgs = (fun x =>
  (
    std.record.map
      (fun k v => let v2 = (v & { name | priority 100 = keyToName k }) in std.seq v2.drvHash (std.record.freeze v2))
      x
  )
)
in
let importlib = (import "lib.ncl")
in

let imported_unnanmed = import "pkgsImport.ncl"
in
let imported = imported_unnanmed
in
let filter_pkgs = (fun x =>
  std.record.filter
    (fun name _ =>
      name != "distro"
    )
    (
      std.record.filter
        (fun name _ =>
          name != "drvs"
        )
        (
          std.record.filter
            (fun name _ =>
              name != "lib"
            )
            (
              std.record.filter
                (fun name _ => name != "pkgs")
                (x)
            )
        )
    )
)
in

let ro = {

  # __pkgs_unfiletered,
  r1 = {
    __pkgs_unfiletered = (
      name_pkgs (
        (
          importlib
          & imported
        )
        & {
          lib,
          pkgs = std.record.map_values (fun v => std.seq v.drvHash std.record.freeze v) __pkgs_unfiletered,
          drvs =
            std.record.map
              (fun k v =>
                (
                  std.record.freeze ({
                    name = keyToName k,
                    keyName = k,
                    drvHash = v.drvHash,
                  }
                  )
                )
              )
              (pkgs),
          distro = (import "../distro/default.ncl")
        }
      )
    )
  }
}
in
let __pkgs_unfiletered = ro.r1.__pkgs_unfiletered
in
let __pkgs =
  # name_pkgs
  (filter_pkgs __pkgs_unfiletered)
#( __pkgs_unfiletered)
in
let r = {

  pkgs = (std.record.filter (fun f v => (std.string.substring 0 1 f != "_")) (__pkgs))
}
in
#name_pkgs
r.pkgs
