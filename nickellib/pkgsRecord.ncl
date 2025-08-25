let drvUtils = import "drv.ncl"
in
let keyToName = (import "keyToName.ncl").keyToName in

let name_pkgs = (fun x =>
  (
    std.record.map
      (fun k v => v & { name | priority 100 = keyToName k })
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

  __pkgs_unfiletered,
  r1 =
    let drvs_nameonly =
      std.record.map
        (fun k v =>
          v
          & {
            name = keyToName k,
            drvHash | default = "204a9243c33380ce82fc6019dabcafc010a66c9b2a6cb0f99005b048248f08c5",
          }
        )
        (imported & { drvs = std.record.map (fun k v => { name = keyToName k }) (imported & { drvs = {} }) } & importlib)
    in
    {
      __pkgs_unfiletered = (
        name_pkgs (
          (
            importlib
            & imported
          )
          & {
            lib,
            pkgs = __pkgs_unfiletered,
            drvs =
              std.record.map
                (fun k v =>
                  # std.trace k
                  {
                    name = keyToName k,
                    keyName = k,
                    drvHash = v.drvHash,
                  }
                )
                (__pkgs_unfiletered)
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
