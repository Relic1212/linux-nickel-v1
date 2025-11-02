{
  lib,
  drvs,
  librsvg | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/librsvg/-/archive/2.59.2/librsvg-2.59.2.tar.gz",
      sha256sum = "ddd8e51426b41ef886898dc4198ca48d7e296668be19595173631fc86c79d689",
    },

    sourceInputs =
      [
        {
          src = singleSource
        }
      ]
      @ (
        let crates = lib.functions.filterCrates (import "librsvg-crates.json") in
        let cratesArray = std.array.flatten (std.array.map (std.record.values) (std.record.values crates))
        in
        (std.array.map (fun c => c.sourceInput) cratesArray)
      ),

    preConfigurePhase = [
      # m%"sed -i "s|'--release'|'--release', '--offline'|g" ${SRC}/meson.build"%,
      m%"export RUSTFLAGS="-C target-feature=+crt-static -C link-self-contained=yes -C link-arg=-static -C link-arg=--static""%,
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
      m%"sed -i 's|shared_library|library|g' ${SRC}/rsvg/meson.build"%,
    ],

    extraMesonArgs = [
      "-Dtriplet='x86_64-unknown-linux-musl'",
      "-Dvala=disabled",
      "-Ddocs=disabled",
      "-Dintrospection=disabled",
      "-Dpixbuf-loader=disabled",
    ],

    # useSccache = false,
    llvmProvider = drvs.llvmFull,

    biDrvs = [
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobject,
      drvs.cargoC,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.gdkPixbufFull,
      drvs.glibDynamic,
      drvs.gobjectDynamic,
      drvs.gperf,
      drvs.graphene,
      drvs.harfbuzzFull,
      drvs.hwdata,
      drvs.libdrm,
      drvs.libelf,
      drvs.libepoxy,
      drvs.libffi,
      drvs.libjpegTurbo,
      drvs.libpciaccess,
      drvs.libpng,
      drvs.libtiff,
      drvs.libxkbcommon,
      drvs.libxml2,
      drvs.linuxHeaders,
      drvs.llvmConfigStatic,
      drvs.mesa2,
      drvs.muslShared,
      drvs.ncurses,
      drvs.pango,
      drvs.pcre2,
      drvs.pixman,
      drvs.readline,
      drvs.rust,
      drvs.spirvLlvmTranslator,
      drvs.spirvTools,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.zlibNg,
      drvs.clangCc,
    ]
  }
}
