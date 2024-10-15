let lib = import "lib.ncl"
in

let drvUtils = {
  jsonToHash = (fun j => lib.computeSha256 j),
  drvToJson = (fun drv => std.serialize 'Json drv),
  drvToHash = (fun drv => let j = drvToJson drv in jsonToHash j),
  pkgToHash = (fun p => let drv = pkgToDrv p in drvToHash drv),
  srcInputToHash = fun s => { src = s.src.sha256sum, dest = s.dest },
  pkgToDrv = (fun p =>
    let p2 = (
      if (std.record.has_field "buildInputs" p) then
        (p & { buildInputs|force=[],buildInputDrvs | force = std.array.map pkgToHash p.buildInputs })
      else
        p
    )
    in
    if (std.record.has_field "srcs" p2) then
      (p2 & { srcs | force = [],src_drvs | force = std.array.map srcInputToHash p2.srcs  })
    else
      p2
  ),
  pkgToJson = (fun p => let drv = pkgToDrv p in drvToJson drv)
}
in
drvUtils
