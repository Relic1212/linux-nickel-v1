let drvUtils = import "../nickellib/drv.ncl"
in
let keyToName = (import "keyToName.ncl").keyToName
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
}
in

let pkgs =
  std.record.filter (fun k v => v.buildEnv.TARGET == null) (import "pkgsRecord.ncl").pkgs
in

let r = {
  pkgsNative = pkgs,
  pkgsTarget = std.record.map_values (fun v => v & { buildEnv.TARGET | force = "aarch64-unknown-linux-musl" }) pkgs
}
in
let x = {
  pkgsNative = std.record.map_values functions.showPkg2 pkgs,
  pkgsTarget = std.record.map_values functions.showPkg2 r.pkgsTarget,
}
in
x
#std.record.map (fun k v => functions. showPkg2 v ) pkgs
