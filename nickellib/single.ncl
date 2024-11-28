let drvUtils = import "../nickellib/drv.ncl"
in let keyToName = (import "keyToName.ncl").keyToName
in

let functions = {
  showPkg = (fun p =>
    (
      std.record.filter
        (fun k v =>
          (
            std.array.elem
              k
              [
                # "baseBuildinputPackages",
                # "baseName",
                # "biPkgs",
                "buildDir",
                "buildEnv",
                "buildInChroot",
                "buildInputs",
                "buildPhase",
                "cdBuildPhase",
                # "commands",
                "configureFlags",
                "configurePhase",
                "configureScript",
                "enableCcache",
                "enableParallel",
                "envSetupPhase",
                "extraConfigureFlags",
                "extraEnv",
                "extraFiles",
                "extraMakeArgs",
                "extraMakeInstallArgs",
                "filesDir",
                # "hasValidBuildInputs",
                "installPhase",
                "isLlvm",
                "isStatic",
                "makeArgs",
                "makeInstallArgs",
                "makeInstallTargets",
                "makeTargets",
                "name",
                "patchDir",
                "patchPhase",
                "patches",
                "phases",
                "postInstallPhase",
                "preBuildPhase",
                "preConfigurePhase",
                "preInstallPhase",
                "scriptContent",
                "separateBuildDir",
                # "singleSource",
                "sourceInputs",
                "stage",
                "unpackPhase",
                # "utilsProviders"
              ]
          )
        )
        p
    )
  ),

  showPkg2 = (fun p =>
    (
      std.record.filter
        (fun k v =>
          (
            std.array.elem
              k
              [
                "buildInChroot",
                "buildInputs",
                "commands",
                "buildEnv",
                "enableCcache",
                "extraEnv",
                "extraFiles",
                "isLlvm",
                "isStatic",
                "name",
                "patches",
                "sourceInputs",
              ]
          )
        )
        p
    )
  ),

  getBiClosure = (fun p1 kbn pkgs => 
  
  let subf = (fun p ssf =>
  ([p] @ (std.array.flatten (std.array.map ( fun bi => ssf  pkgs."%{ kbn."%{bi.name}" }" ) p.buildInputs)))) 
  in 
  subf p1 subf
   ),
}
in

let pkgs =
  std.record.filter (fun k v => v.buildEnv.TARGET == null) (import "pkgsRecord.ncl").pkgs
in

let imported = (import "pkgsRecord.ncl").pkgs
in

let r = {
  pkgsNative = pkgs,
  pkgsTarget = std.record.map_values (fun v => v & { buildEnv.TARGET | force = "aarch64-unknown-linux-musl" }) pkgs
}
in let x = {
  pkgsNative = std.record.map_values functions.showPkg2 pkgs,
  pkgsTarget = std.record.map_values functions.showPkg2 r.pkgsTarget,
}
in
# x
# std.record.map (fun k v => functions. showPkg2 v ) pkgs
let _p =
  std.record.map (fun k v => (v & { drvSha256sum = drvUtils.pkgToHash v })) pkgs
in let y =
  std.record.map_values (fun v => v.drvSha256sum) _p
in let f = {
  __pkgs =
    # std.record.remove
    #   "hashByName"
    (
      std.record.remove
        "lib"
        (
          std.record.remove
            "pkgs"
            (
              std.record.map
                (fun k v => v & { key = k, name | priority 100 = keyToName k, drvSha256sum = drvUtils.pkgToHash v })
                (
                  (
                    (import "lib.ncl") &
                    #&
                    imported
                  )
                  & { pkgs = __pkgs }
                )
              & { pkgs, hashByName = std.record.map_values (fun p => std.record.get_or "drvSha256sum" null p) __pkgs }
            )
        )
    ),
}
in

# std.record.from_array (f.__pkgs.hashByName

# f.__pkgs.mesa2.drvHash

let 
keyByName =  std.record.from_array (std.record.values (std.record.map (fun f v => { field = v.name, value = v.key })    ( std.record.filter (fun k v => std.record.has_field "buildInputs" v) f.__pkgs)))

in
# keyByName
functions.getBiClosure f.__pkgs.musl keyByName f.__pkgs