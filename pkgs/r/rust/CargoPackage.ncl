{
  drvs,
  lib = {

    Package,
    SourceInput,

    functions = {
      importCrates = (fun j =>
        let crate | Crate
          = {
            name = j.name,
            version = j.version,
            meta = {}
          }
          in
        crate
      )
    },

    CargoPackage =
      Package
      & {
        utilsProviders,
        llvmProvider,
        singleSource,
        baseBuildinputPackages | priority -1000
          =
            [
              drvs.rust,
              drvs.muslShared,
              drvs.pkgconf,
              llvmProvider,
            ]
            @ utilsProviders,

        enableCcache | priority -1000 = false,
        separateBuildDir | priority -1000 = false,

        buildPhase | priority -1000
          = [
            "cargo build --offline"
          ],

        nonCrateSourceInputs | not_exported | Array SourceInput | default = if (singleSource == null) then [] else [{ src = singleSource }],

        crates | not_exported | Array Crate | default = [],

        crateSourceInputs | not_exported | Array SourceInput | default = (std.array.map (fun c => c.sourceInput) crates),

        sourceInputs | priority -1000 = nonCrateSourceInputs @ crateSourceInputs,
      },

    Crate = {
      name | String,
      version | String,
      uri | String | default = "https://crates.io/api/v1/crates/%{name}/%{version}/download",
      sha256sum | String,
      meta = {
        source | String | optional,
        dependencies | optional,
      },
      unpackCommands | Array String | default
        = [
          "mkdir -p ${SRC}/vendor/%{name}",
          "(cd  ${SRC}/vendor/%{name}; tar -xf /tmp/packed/%{sha256sum}/download --strip-components=1)",
        ],

      sourceInput | default
        = {
          dest = "vendor/%{name}",
          src =
            let _uri = uri in
            let _sha = sha256sum in
            {
              uri = _uri,
              sha256sum = _sha,
            }
        }
    }
  }
}
