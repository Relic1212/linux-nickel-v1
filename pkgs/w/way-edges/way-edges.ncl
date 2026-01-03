{
  lib,
  drvs,
  wayEdges | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/way-edges/way-edges/archive/refs/tags/0.11.1.tar.gz",
      sha256sum = "529ea6d0100aa67c5921323c794a2735b9ccc219796b0448de8dc209805bc351"
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
        dest = "vendor-pulse-binding-rust"
      },
      {
        src = {
          uri = "https://github.com/Smithay/client-toolkit/archive/9aeccd9047ec631eafcd4dd63f9420b7fc3cc8d7.tar.gz",
          sha256sum = "b997489512ebf83db28fdc96e574ee50b401ffae56dfdabdbbf610f5300647b5"
        },
        dest = "vendor/smithay-client-toolkit"
      }
    ],

    crates = lib.functions.filterCrates (import "way-edges-crates.json"),

    patches = [
      {
        file = "way-edges.patch",

        sha256sum = "8eaa4549ff48d5ec2c00de200fdd4f0377b1d157b07bc7267e9c08cd62ad345d"
      },
    ],

    extraEnv.EXTRA_RUSTFLAGS = [
      "--cfg tokio_unstable",
      "--cfg tokio_uring",
      "-C link-arg=-L/usr/lib/pulseaudio",
      "-C link-arg=-lpulsecommon-17.0",
      "-C link-arg=-ldbus-1",
    ],

    configurePhase = [
      m%"
      echo "

      
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

      [source.\"git+https://github.com/Smithay/client-toolkit.git#9aeccd9047ec631eafcd4dd63f9420b7fc3cc8d7\"]
      git = \"https://github.com/Smithay/client-toolkit.git\"
      replace-with = \"vendored-sources\"

      " >> ${SRC}/.cargo/config.toml
      "%,
      "(cd vendor-pulse-binding-rust && cargo package --exclude-lockfile --no-verify)",
      "cp vendor-*/target/package/*.crate vendor/",
      "rm vendor/libpulse-glib-binding-2.29.0.crate",
      "rm vendor/libpulse-mainloop-glib-sys-1.22.0.crate",
      "rm vendor/libpulse-simple-binding-2.29.0.crate",
      "rm vendor/libpulse-simple-sys-1.22.0.crate",
      "(cd vendor/ && for f in $(ls *.crate); do mv ${f} ${f}.tar.gz; tar xf ${f}.tar.gz; done)",

      # "rm vendor/libpulse-sys-1.23.0.crate.tar.gz",
      # "rm vendor/libpulse-tokio-0.1.1.crate.tar.gz",
      m%"(cd vendor && for d in $(ls); do if [ -d ${d} ];then if [ ! -e ${d}/.cargo-checksum.json ];then echo '{"files":{},"package":null}' > ${d}/.cargo-checksum.json;fi;fi;done)"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/Cargo.toml"%,

      # m%"sed -i 's@libpulse-binding@#libpulse-binding@g' ${SRC}/crates/backend/Cargo.toml"%,
      # m%"sed -i 's@libpulse_binding@libpulse_tokio::pulse@g' ${SRC}/crates/backend/src/pulseaudio/change.rs"%,
      # m%"sed -i 's@libpulse_binding@libpulse_tokio::pulse@g' ${SRC}/crates/backend/src/pulseaudio/pa.rs"%,
    ],

    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.pixman,
      drvs.zlibNg,
      drvs.freetype,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.cairo,
      drvs.pulseaudio17,
      drvs.dbus,
    ],
  }
}
