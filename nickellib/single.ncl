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
(std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs).baseRootfs

# drvUtils.pkgToJson pkgs.baseRootfs
