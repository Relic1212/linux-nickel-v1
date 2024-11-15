{
  lib,
  drvs,
  uutils | lib.CargoPackage
    = 
    let j = import "./uutils/uutils-packages.json" 
    in 
    let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v )  ((lib.functions.importCrates) j )
    in 
    
    {
      nonCrateSourceInputs = [
        {
          src = {
            uri = "https://github.com/uutils/coreutils/archive/refs/tags/0.0.27.tar.gz",
            sha256sum = "3076543a373c8e727018bd547cc74133f4a6538849e4990388f2bbea9a9aff6b"
          }
        }
      ],
      biDrvs = [
        # drvs.clangCc,
      ],

      separateBuildDir = false,
      crates = _crates,
      extraCargoFlags = [
        "--features=feat_os_unix_musl"
      ],

      # crates.uuhelp_parser."0.0.27".sha256sum = "1",
      preConfigurePhase = [ 
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
      target,
       installPhase = [
        "install -d -m0755 ${DEST}/usr/bin",
        "install -m0755 target/%{target}/release/coreutils ${DEST}/usr/bin",
      ]
      
    }
}