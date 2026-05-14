let drvUtils = import "../nickellib/drv.ncl"
in

let pkgsAll = std.record.map (fun k v => v & { keyName | force = k, f = false }) (import "pkgsRecord.ncl")
in
# let needed = std.record.map (fun k v => { f =false}) pkgsAll in
let rec f1 = (fun pkgs p =>
  # std.trace "p=%{p}"
  (
    if (pkgs."%{p}".f) then
      pkgs
    else
      std.array.fold_left (f1) (pkgs & { "%{p}".f | priority 1 = true }) (std.array.map (fun s => s.keyName) (pkgsAll."%{p}".buildInputs))
  )
)
in

let getData = (fun pkgs =>
  (
    let si_all =
      std.record.merge_all (
        std.array.map
          (fun si => { "%{si.src.sha256sum}" = std.serialize 'Json si.src })
          (std.array.flatten (std.record.values (std.record.map_values (fun p => p.sourceInputs) pkgs)))
      )
    in

    let data = {
      pkghash2sysroothash = {},

      drvByHash = (std.record.from_array (std.record.values (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs))) & si_all,

      hashByName = std.record.merge_all (std.record.values (std.record.map_values (fun v => { "%{v.name}" = v.drvHash }) pkgs)),
    }
    in
    data
  )
)
in

{
  pn | String,

  # data = f1 needed pn ,# pkgsAll.busybox.keyName,
  #include needed

  data = if (pn == "") then (getData pkgsAll) else (let filtered = std.record.filter (fun k v => v.f) (f1 pkgsAll pn) in getData filtered),
  # data = let filtered = std.record.filter (fun k v => v.f) (f1 needed pn) in getData ( std.record.filter (fun k v=>filtered."%{k}") pkgsAll),
}
