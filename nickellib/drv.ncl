let lib = import "lib.ncl"
in

let 
DrvSchema={
  name|String,
  buildInputDrvs|Array String,
  scriptContent|String,
  sourceInputDrvs|Array Dyn,
  extraFiles|Array String ,
  patches|Array String
}
in
let drvUtils = {
  
  jsonToHash = (fun j => lib.functions.computeSha256 j),
  drvToJson = (fun drv => std.serialize 'Json drv),
  drvToHash = (fun drv => let j = drvToJson drv in jsonToHash j),
  pkgToHash = (fun p => let drv = pkgToDrv p in drvToHash drv),
  srcInputToHash = fun s => { src = s.src.sha256sum, dest = s.dest },
  pkgToDrv1 = (fun p =>
    let p2 = (
      if (std.record.has_field "buildInputs" p) then
        (p & { buildInputs|force=[],buildInputDrvs | force = std.array.map pkgToHash p.buildInputs })
      else
        p
    )
    in
    if (std.record.has_field "sourceInputs" p2) then
      (p2 & { sourceInputs | force = [],sourceInputsDrvs | force = std.array.map srcInputToHash p2.sourceInputs  })
    else
      p2
  ),
  pkgToDrv = (fun p => let d|DrvSchema ={
    name =p.name,
    buildInputDrvs=std.array.map pkgToHash p.buildInputs ,
    sourceInputDrvs= if (std.record.has_field "sourceInputs" p) then (std.array.map srcInputToHash p.sourceInputs)else [],
    patches=p.patches,
    extraFiles=p.extraFiles,
    scriptContent=p.scriptContent
  } in d),
  pkgToJson = (fun p => let drv = pkgToDrv p in drvToJson drv),
  pkgToFullDrv = (fun p=>{
    package={
    name=p.name,
       hash =pkgToHash p ,
        drv = pkgToJson p}
        ,
      sourceInputs =  std.array.map (fun s=> { hash=s.src.sha256sum, drv = std.serialize 'Json s.src  }) p.sourceInputs,
#      buildInputs= std.array.map pkgToFullDrv p.buildInputs 
  })
}
in
drvUtils
