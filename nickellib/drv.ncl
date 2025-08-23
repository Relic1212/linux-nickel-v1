let lib = (import "lib.ncl").lib
in
let drvData = {
  drvHash | String,
  dest | String | default = ""
}
in

let DrvSchema = {
  buildInputDrvs | Array Dyn,
  scriptContent | String,
  sourceInputDrvs | Array Dyn,
  extraFileDrvs | Array Dyn,
  patchDrvs | Array Dyn,
  buildInChroot | Bool,
  enableCcache | Bool,
  symlinkBuldInputs | Bool,
  deterministicFetcher | optional,
  outputFile | optional,
  outputSha256sum | optional,
}
in
let drvUtils = {

  jsonToHash = (fun j => lib.functions.computeSha256 j),
  drvToJson = (fun drv => std.serialize 'Json drv),
  drvToHash = (fun drv => let j = drvToJson drv in jsonToHash j),
  pkgToHash = (fun p => let drv = pkgToDrv p in drvToHash drv),
  sortStringArray = (fun arr => (std.array.sort std.string.compare arr)),
  # pkgOrHashToHash = (fun ps =>
  #   (
  #     if (std.is_string ps) then
  #       (
  #         if ((std.string.length ps) == 64) then
  #           ps
  #         else
  #           (pkgToHash ps)
  #       )
  #     else
  #       (pkgToHash ps)
  #   )
  # ),
  srcInputToHash = fun s => { src = s.src.sha256sum, dest = if (std.record.has_field "dest" s) then s.dest else "" },

  buildInputCmp = (fun bi1 bi2 =>
    let bi1_prio = std.record.get_or "priority" 0 bi1 in
    let bi2_prio = std.record.get_or "priority" 0 bi2 in
    if (bi1_prio == bi2_prio) then
      std.string.compare bi1.drvHash bi2.drvHash
    else
      std.number.compare bi1_prio bi2_prio
  ),

  pkgToDrv = (fun p =>
    let d | DrvSchema =
      {
        # buildInputDrvs = sortStringArray (std.array.map (fun x => x.drvHash) p.buildInputs),

        buildInputDrvs = (
          std.array.map
            (fun x =>
              let data = { drvHash = x.drvHash, dest = std.record.get_or "dest" "" x } in
              if data.dest == "" then
                data.drvHash
              else
                data
            )
            (std.array.sort (buildInputCmp) p.buildInputsValidated)
        ),

        sourceInputDrvs = if (std.record.has_field "sourceInputs" p) then (std.array.map srcInputToHash p.sourceInputs) else [],
        patchDrvs = p.patches,
        extraFileDrvs = p.extraFiles,
        scriptContent = p.scriptContent,
        buildInChroot = p.buildInChroot,
        enableCcache = p.enableCcache,
        symlinkBuldInputs = p.symlinkBuldInputs,
      }
      & (
        if p.deterministicFetcher then
          {
            deterministicFetcher = p.deterministicFetcher,
            outputFile = p.outputFile,
            outputSha256sum = p.outputSha256sum
          }
        else
          {}
      )
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
          @ (std.array.flatten (std.array.map toDrvsByhashArray p.buildInputsValidated))
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
      hashByName = std.record.from_array (std.array.filter (fun x => x.field != null) (std.array.map (fun x => { field = x.value.name, value = x.field }) (std.record.to_array d)))
    }
  ),
  toDrvsByhashOnly = (fun p =>
    (
      std.record.map_values
        (fun x =>
          {
            "%{pkgToHash x}" = pkgToJson p
          }
        )
        p
    )
  ),
  # hashByName=std.record.map_values (fun v=>pkgToHash v) pkgs,
}
in
drvUtils
