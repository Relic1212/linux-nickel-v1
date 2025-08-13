{
  lib,
  drvs,
  wayEdges | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/way-edges/way-edges/archive/refs/tags/0.10.0.tar.gz",
      sha256sum = "ca50e9287478da259dbaebf7a879aab033becc618c3fb729b9da105e3ccd07e7"
    },

    nonCrateSourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://github.com/ogios/freedesktop-icons/archive/807964d45063d6911a58595d733aa1fbf2197874.tar.gz",
          sha256sum = "7eabcf75c91929a33f2d3d0fa6766fd6199d913e8b1bac339142eb016acc75d4"
        },
        dest = "vendor/freedesktop-icons"
      },
      {
        src = {
          uri = "https://git.sr.ht/~zethra/linicon-theme/archive/ae30a81cad23bb3b77a4c836baec39946eab862d.tar.gz",
          sha256sum = "940743720078f0156f78c2a5bd02d0179496b21b907889fcf5a674346c945181"
        },
        dest = "vendor/linicon-theme"
      },
      {
        src = {
          uri = "https://github.com/ogios/pulse-binding-rust/archive/cdfc0cba51b03dc756f547bd214e1014c226af67.tar.gz",
          sha256sum = "0926ac4430775e6e4daff488aa1b875ccbc1f249bad9b0ec1bbae408363a1696"
        },
        dest = "vendor/pulse-binding-rust"
      },
      {
        src = {
          uri = "https://github.com/Smithay/client-toolkit/archive/9882c58bd1a84a23fb263a01a4f78b9f75d35e41.tar.gz",
          sha256sum = "1390080df5977bc1d20ef6612ffc53218a11401069d3cc8ca0e9883671ed6fb3"
        },
        dest = "vendor/smithay-client-toolkit"
      }
    ],

    crates = lib.functions.filterCrates (import "way-edges-crates.json"),

    configurePhase = [
      m%"
            echo "
            [source.crates-io]
            replace-with = \"vendored-sources\"
            


            [source.\"git+https://github.com/ogios/freedesktop-icons?branch=use#807964d45063d6911a58595d733aa1fbf2197874\"]
            branch = \"use\"
            git = \"https://github.com/ogios/freedesktop-icons\"
            replace-with = \"vendored-sources\"

            [source.\"git+https://git.sr.ht/~zethra/linicon-theme?branch=main#ae30a81cad23bb3b77a4c836baec39946eab862d\"]
            branch = \"main\"
            git = \"https://git.sr.ht/~zethra/linicon-theme\"
            replace-with = \"vendored-sources\"

            [source.\"git+https://github.com/ogios/pulse-binding-rust.git?branch=tokio-bindings#cdfc0cba51b03dc756f547bd214e1014c226af67\"]
            branch = \"tokio-bindings\"
            git = \"https://github.com/ogios/pulse-binding-rust.git\"
            replace-with = \"vendored-sources\"

            [source.\"git+https://github.com/Smithay/client-toolkit.git#9882c58bd1a84a23fb263a01a4f78b9f75d35e41\"]
            git = \"https://github.com/Smithay/client-toolkit.git\"
            replace-with = \"vendored-sources\"


            [source.vendored-sources]
            directory = \"vendor\"

            " > ${SRC}/.cargo/config.toml
            "%,
      "cp -r vendor/pulse-binding-rust/libpulse-binding vendor/libpulse-binding",
      "cp -r vendor/pulse-binding-rust/libpulse-sys vendor/libpulse-sys",
      "cp -r vendor/pulse-binding-rust/libpulse-tokio vendor/libpulse-tokio",
      m%"
        for d in $(ls vendor); do 
            if [ ! -f vendor/${d}/.cargo-checksum.json ]; then 
                cp vendor/log-0.4.27/.cargo-checksum.json vendor/${d}/.cargo-checksum.json
            fi
        done
        "%
    ],
  }
}
