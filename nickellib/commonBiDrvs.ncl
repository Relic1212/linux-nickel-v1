let pkgsAll = (import "pkgsRecord.ncl")
in

let getNames = (fun p => std.array.map (fun x => x.keyName) p.biDrvs)
in
let f1 = (fun pkgs =>
  let names_ll = std.array.map (getNames) pkgs
  in
  let names_l = std.array.flatten names_ll
  in

  let unique = std.array.dedup names_l
  in
  std.array.sort (std.string.compare) unique
# names_l
)
in
let getDepStr = (fun pkgs =>
  let names = f1 pkgs in

  let l = std.array.map (fun n => "drvs.%{n}, ") names in

  std.string.join "" l
)
in
getDepStr [pkgsAll.dinit, pkgsAll.niri, pkgsAll.pipewire]
