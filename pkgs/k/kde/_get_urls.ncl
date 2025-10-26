let x = import "kf6.ncl"
in

let fi =
  std.record.fields x
in
let vals = std.array.map (fun s => std.record.get_or s null x) fi
in
let rs = std.array.filter (fun v => std.is_record v) vals
in
let ss = std.array.filter (fun v => std.record.has_field "singleSource" v) rs
in ss
