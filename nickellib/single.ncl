let drvUtils = import "../nickellib/drv.ncl"
in
let keyToName = (import "keyToName.ncl").keyToName
in

let pkgs =
  (import "pkgsRecord.ncl").pkgs
in

let si_all =
  std.record.merge_all (
    std.array.map
      (fun si => { "%{si.src.sha256sum}" = std.serialize 'Json si.src })
      (std.array.flatten (std.record.values (std.record.map_values (fun p => p.sourceInputs) pkgs)))
  )
in
let s = {
  bsdrv = (std.record.map_values (fun x => { field = "%{drvUtils.pkgToHash x}", value = drvUtils.pkgToJson x }) pkgs).baseRootfs
}
in
let 
# std.record.values (std.record.map (fun k v=>(keyToName k)) pkgs)

# std.array.map keyToName  (std.record.fields pkgs )
x=std.record.map
  (fun k v =>
    if (keyToName k) == (v.name) then
      ""
    else
      m%"
WARNING
name=%{v.name}
but according to the choesen key %{k}
is should be
%{keyToName k}
"%
  )
  (pkgs)


# drvUtils.pkgToJson pkgs.baseRootfs

in 
pkgs.baseImage
