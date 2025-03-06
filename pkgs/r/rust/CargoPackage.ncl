{
  drvs,
  lib = {

    Package,
    SourceInput,

    functions = {
      importCrate = (fun j =>
        let crate | Crate = {
          name | default = std.record.get_or "name" "NULL" j,
          version | default = std.record.get_or "version" "NULL" j,
          sha256sum | default = std.record.get_or "checksum" "NULL" j,
          meta = {
            source | default = std.record.get_or "source" "NULL" j,
          }
        }
        in
        crate
      ),
      importCrates = (fun js =>
        std.array.map
          (fun j =>
            let _crate = importCrate j in
            {
              # "%{j.name}-%{j.version}"
              "%{_crate.name}" = { "%{_crate.version}" = _crate },
            }
          )
          js
        |> std.record.merge_all
      ),

      importCargoLock = (fun toml => ((importCrates (toml.package)))),

      filterCrates = (fun j =>
        let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
        in _crates
      ),
    },

    CargoPackage =
      Package
      & {
        utilsProviders,
        llvmProvider,
        singleSource,
        buildEnv,
        target = (if buildEnv.TARGET == null then "x86_64-unknown-linux-musl" else buildEnv.TARGET),
        extraEnv = {
          STATIC_RUSTFLAGS | default = [
            "-C target-feature=+crt-static",
            "-C link-self-contained=yes",
            "-C link-arg=-static",
            "-C link-arg=--static"
          ],
          EXTRA_RUSTFLAGS | default = [],
          RUSTFLAGS | default = STATIC_RUSTFLAGS @ EXTRA_RUSTFLAGS,
        },

        baseBuildinputPackages | priority -1000 =
          [
            drvs.rust,
            drvs.muslShared,
            drvs.pkgconf,
            llvmProvider,
            drvs.clangCc,
          ]
          @ utilsProviders,

        enableCcache | priority -1000 = false,
        separateBuildDir | priority -1000 = false,
        extraCargoFlags | Array String | default = [],
        release | Bool | default = true,
        preConfigurePhase | priority -1000 = [
          m%"
            for d in $(ls  ${SRC}/vendor); do
              if [ -e ${SRC}/vendor/${d}/download ]; then
                mv  ${SRC}/vendor/${d}/download  ${SRC}/vendor/${d}/download.tar.gz
                tar -xf ${SRC}/vendor/${d}/download.tar.gz --strip-components=1 -C ${SRC}/vendor/${d}/
                echo '{"package":"'"$(sha256sum ${SRC}/vendor/${d}/download.tar.gz|cut -d ' ' -f1)"'","files":{}}' >  ${SRC}/vendor/${d}/.cargo-checksum.json
              fi
            done
            "%,
          "mkdir -p ${SRC}/.cargo",
          m%"
            echo "

            [source.crates-io]
            replace-with = \"vendored-sources\"

            [source.vendored-sources]
            directory = \"vendor\"

            " >> ${SRC}/.cargo/config.toml
            "%,
          "export CARGO_HOME=${SRC}/.cargo",
        ],
        releaseFlags | default =
          if release then
            [
              "--release",
            ]
          else
            [],
        baseCargoFlags | default = [
          "--offline",
          "--target %{target}"
        ],
        cargoFlags | default = releaseFlags @ baseCargoFlags @ extraCargoFlags,
        buildPhase | priority -1000 = [
          "cargo build %{std.string.join "\t\\\n" cargoFlags}"
        ],
        artefactDir | default = if release then "${SRC}/target/%{target}/release" else "${SRC}/target/%{target}/debug",

        installPhase | priority -1000 = [
          "install -d -m0755 ${DEST}/usr/bin",
          m%"
          for f in $(ls %{artefactDir}); do
            file_end=$(echo $f| rev | cut -d '.' -f1|rev)

            if [ -f "%{artefactDir}/${f}" ] \
              && [ ! "$file_end" = "d" ] \
              && [ ! "$file_end" = "rlib" ]; then

              install -m0755 "%{artefactDir}/${f}" \
                ${DEST}/usr/bin

            fi
          done
          "%
        ],

        nonCrateSourceInputs | not_exported | Array SourceInput | default = if (singleSource == null) then [] else [{ src = singleSource }],

        lockfileImport | default = null,
        crates | default = if (lockfileImport == null) then {} else (lib.functions.importCargoLock lockfileImport),

        cratesArray | not_exported | default = std.array.flatten (std.array.map (std.record.values) (std.record.values crates)),

        crateSourceInputs | not_exported | Array SourceInput | default = (std.array.map (fun c => c.sourceInput) cratesArray),

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
      unpackCommands | Array String | default = [
        "mkdir -p ${SRC}/vendor/%{name}",
        "(cd  ${SRC}/vendor/%{name}; tar -xf /tmp/packed/%{sha256sum}/download --strip-components=1)",
      ],

      sourceInput | default = {
        dest = "vendor/%{name}-%{version}",
        src =
          let _uri = uri in
          let _sha = sha256sum in
          {
            uri | priority -1 = _uri,
            sha256sum | priority -1 = _sha,
          }
      }
    }
  }
}
