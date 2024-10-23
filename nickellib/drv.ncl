let lib = import "lib.ncl"
in

let DrvSchema = {
  name | String,
  buildInputDrvs | Array String,
  scriptContent | String,
  sourceInputDrvs | Array Dyn,
  extraFileDrvs | Array Dyn,
  patchDrvs | Array Dyn,
  buildInChroot | Bool,
  enableCcache | Bool
}
in
let drvUtils = {

  jsonToHash = (fun j => lib.functions.computeSha256 j),
  drvToJson = (fun drv => std.serialize 'Json drv),
  drvToHash = (fun drv => let j = drvToJson drv in jsonToHash j),
  pkgToHash = (fun p => let drv = pkgToDrv p in drvToHash drv),
  srcInputToHash = fun s => { src = s.src.sha256sum, dest = if (std.record.has_field "dest" s) then s.dest else "" },
  pkgToDrv1 = (fun p =>
    let p2 = (
      if (std.record.has_field "buildInputs" p) then
        (p & { buildInputs | force = [], buildInputDrvs | force = std.array.map pkgToHash p.buildInputs })
      else
        p
    )
    in
    if (std.record.has_field "sourceInputs" p2) then
      (p2 & { sourceInputs | force = [], sourceInputsDrvs | force = std.array.map srcInputToHash p2.sourceInputs })
    else
      p2
  ),
  pkgToDrv = (fun p =>
    let d | DrvSchema
      = {
        name = p.name,
        buildInputDrvs = std.array.map pkgToHash p.buildInputs,
        sourceInputDrvs = if (std.record.has_field "sourceInputs" p) then (std.array.map srcInputToHash p.sourceInputs) else [],
        patchDrvs = p.patches,
        extraFileDrvs = p.extraFiles,
        scriptContent = p.scriptContent,
        buildInChroot = p.buildInChroot,
        enableCcache = p.enableCcache
      }
      in d
  ),
  pkgToJson = (fun p => let drv = pkgToDrv p in drvToJson drv),
  pkgToFullDrv = (fun p =>
    {
      package = {
        name = p.name,
        hash = pkgToHash p,
        drv = pkgToJson p
      },
      sourceInputs = std.array.map (fun s => { hash = s.src.sha256sum, drv = std.serialize 'Json s.src }) p.sourceInputs,
      #      buildInputs= std.array.map pkgToFullDrv p.buildInputs
    }
  ),
  sourceInputTohasBasedDrv = (fun s => { "%{s.sha256sum}" = { drv = std.serialize 'Json s, name = null } }),
  toDrvsByhashArray = (fun p =>
    [
      {
        "%{pkgToHash p}" = { drv = pkgToJson p, name = p.name },
      }
    ]
    @ (
      std.array.map
        (fun x =>
          x
        #{ field = x.field, value = { drv = x.value.drv, name = null } }
        )
        (
          []
          @ (std.array.flatten (std.array.map toDrvsByhashArray p.buildInputs))
          @ (std.array.map (fun s => sourceInputTohasBasedDrv s.src) p.sourceInputs)
          @ (std.array.map sourceInputTohasBasedDrv (p.patches @ p.extraFiles))
        )
    )
  ),
  # toDrvsByhash = (fun p => { drvByHash = std.record.from_array (std.array.map (fun d => { field = d.field, value = d.value.drv }) (toDrvsByhashArray p)), hashByName = std.record.from_array (std.array.map (fun d => { field = d.value.name, value = d.field }) (std.array.filter (fun x => x.value.name != null) (toDrvsByhashArray p))) }),
  toDrvsByhash = (fun p =>
    let d = std.record.merge_all (toDrvsByhashArray p) in
    {
      drvByHash = std.record.map_values (fun x => x.drv) d,
      hashByName = std.record.from_array ( std.array.filter (fun x=>x.field!=null) (std.array.map (fun x =>  { field=x.value.name,value=x.field }) (std.record.to_array d)))
    }
  )
}
in
drvUtils
