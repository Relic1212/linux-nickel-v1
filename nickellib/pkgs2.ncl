let drvUtils = import "../nickellib/drv.ncl"
in

let pkgs = (import "pkgsRecord.ncl")
in
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
  let r2 =
    std.record.map
      (fun k v =>
        {
          "%{v.hash}" =
            # v.buildInputs
            { symlinkBuldInputs = v.symlinkBuldInputs, enableCcache = v.enableCcache, buildInputs = std.array.map (fun bi => bi.drvHash) v.buildInputs }
        }
      )
      r1
  in
  let r3 = std.record.map (fun k v => v.hash) r1
  in
  {
    nameToSysroot = r3,
    sysrootDrvs = std.record.merge_all (std.record.values r2),
    pkghash2sysroothash =std.record.merge_all (std.record.values(std.record.map (fun k v => { "%{v.drvHash}" =v.hash} ) r1)),
  }
in
let data = {
  drvByHash = (std.record.from_array (std.record.values (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs))) & si_all,

  # hashByName = std.record.from_array (std.record.values (std.record.map_values (fun x => { field = x.name, value = drvUtils.pkgToHash x }) pkgs)),

  hashByName = std.record.merge_all (std.record.values (std.record.map_values (fun v => { "%{v.name}" = v.drvHash }) pkgs)),
}
in
sysroots & data
