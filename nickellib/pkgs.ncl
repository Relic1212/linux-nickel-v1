let drvUtils = import "../nickellib/drv.ncl"
in

let pkgs =
  import "pkgsRecord.ncl"
in
let si_all =
  std.record.merge_all (
    std.array.map
      (fun si => { "%{si.src.sha256sum}" = std.serialize 'Json si.src })
      (std.array.flatten (std.record.values (std.record.map_values (fun p => p.sourceInputs) pkgs)))
  )
in

{
  drvByHash = (std.record.from_array (std.record.values (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs))) & si_all,

  hashByName = std.record.from_array (std.record.values (std.record.map_values (fun x => { field = x.name, value = drvUtils.pkgToHash x }) pkgs)),
}
# let m= std.array.flatten(std.record.values
# (std.record.map_values (fun x=> x.buildInputs ) pkgs))

# in
# std.array.map (drvUtils.pkgOrHashToHash) m
# (drvUtils.toDrvsByhashOnly) pkgs
