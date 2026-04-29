
let src = import "_kf_sources.ncl" in 
let d = (std.record.map (fun k v => {"%{ std.string.split "/" k |> std.array.last |> std.string.replace "-6.25.0.tar.xz" ""}" = { src = { uri = k , sha256sum = v } }} ) src) in let _d = std.record.values d |> std.record.merge_all

in 
_d
# std.record.map ( fun k v=> 0 ) _d