let drvUtils = import "../nickellib/drv.ncl"
in

let pkgsAll = (import "pkgsRecord.ncl")
in

# filter
let rec _getClosure = (fun data =>
  let
    pkgName =
      # std.trace "pkgName=%{data.pkgName}" 
      data.pkgName,
    satisfiedDepNames = data.satisfiedDepNames
  in

  if std.array.elem pkgName satisfiedDepNames then
    []
  else
    (
      let pkg = pkgsAll."%{pkgName}" in
      let depNames = std.array.map (fun x => x.keyName) pkg.buildInputs
      in
      let newDeps = std.array.filter (fun dn => !(std.array.elem dn satisfiedDepNames)) depNames
      in

      let depExc =
        std.array.fold_left
          (fun satisfiedArg nameArg =>
            let dataArg = { pkgName = nameArg, satisfiedDepNames = satisfiedArg }
            in

            std.array.dedup ((_getClosure dataArg) @ satisfiedArg)
          )
          satisfiedDepNames
          newDeps
      in depExc @ [pkgName]
    )
)
in
let getClosure = (fun pkgNameArg => _getClosure { pkgName = pkgNameArg, satisfiedDepNames = [] })
in
# -filter
let getData = (fun pkgs =>
  (
    let si_all =
      std.record.merge_all (
        std.array.map
          (fun si => { "%{si.src.sha256sum}" = std.serialize 'Json si.src })
          (std.array.flatten (std.record.values (std.record.map_values (fun p => p.sourceInputs) pkgs)))
      )
    in
    let sysroots =
      let r1 =
        std.record.map
          (fun k v =>
            {
              hash =
                std.hash
                  'Sha256
                  (
                    std.serialize
                      'Json
                      ({ symlinkBuldInputs = v.symlinkBuldInputs, enableCcache = v.enableCcache, buildInputs = std.array.map (fun bi => bi.drvHash) v.buildInputs }
                      )
                  ),
              buildInputs = v.buildInputs,
              symlinkBuldInputs = v.symlinkBuldInputs,
              enableCcache = v.enableCcache,
              drvHash = v.drvHash,
            }
          )
          pkgs
      in

      {
        pkghash2sysroothash = std.record.merge_all (std.record.values (std.record.map (fun k v => { "%{v.drvHash}" = v.hash }) r1)),
      }
    in
    let data = {
      drvByHash = (std.record.from_array (std.record.values (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs))) & si_all,

      hashByName = std.record.merge_all (std.record.values (std.record.map_values (fun v => { "%{v.name}" = v.drvHash }) pkgs)),
    }
    in
    sysroots & data
  )
)
in
let fillterPkgsByPkgNmae = (fun pn pkgsArg =>
  let needed = getClosure pn
  in
  let neededPkgs = std.record.filter (fun k v => std.array.elem k needed) pkgsArg
  in

  neededPkgs
)
in
{
  pn | String,

  data = if pn == "" then getData pkgsAll else (getData (fillterPkgsByPkgNmae pn pkgsAll))
}
