let x = {
  _keyToName = (fun s =>
    (
      if (s == std.string.lowercase s) then
        s
      else
        (
          let old_chrs = (std.string.characters s) in
          let new_chrs = (
            std.array.map
              (fun c =>
                (
                  if (c == std.string.lowercase c) then
                    c
                  else
                    "-%{ std.string.lowercase c }"
                )
              )
              old_chrs
          )
          in (std.string.join "" new_chrs)
        )
    )
  ),
  keyToName = (fun s =>
    (
      std.string.replace "Stage0" "Stage-0" s |> std.string.replace "Stage1" "Stage-1" |> std.string.replace "Stage2" "Stage-2" |> std.string.replace "Stage3" "Stage-3" |> _keyToName
    )
  ),

  t = keyToName "python4Dyn",
}
in x
