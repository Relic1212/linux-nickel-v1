let drvUtils = import "../nickellib/drv.ncl"
in
let keyToName = (import "keyToName.ncl").keyToName
in

let 

showPkg = (
  fun p=> (
    std.record.filter (
      fun k v => (std.array.elem k [
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

      ])
    ) p
  )
)

in

let pkgs =
  (import "pkgsRecord.ncl").pkgs
in

let r=
{
  pkgsAarch64 = std.record.map_values (fun v=> v&{buildEnv.TARGET|force ="aarch64-unknown-linux-musl"}) pkgs 
}

in 

std.record.map_values showPkg r.pkgsAarch64