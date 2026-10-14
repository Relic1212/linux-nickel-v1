{
  lib,
  drvs,
  pcre2,
  pcre2cmake | lib.CmakePackage = {

    sourceInputs = pcre2.sourceInputs,
    generator = "Ninja",
    cmakeArgsRecord = {
      "-DPCRE2_BUILD_PCRE2_32" = true,
      "-DPCRE2_BUILD_PCRE2_16" = true,
      "-DPCRE2_BUILD_PCRE2_8" = true,
    }
  }
}
& {
  lib,
  drvs,
  fish4 | lib.CargoPackage = {
    singleSource = {

      uri = "https://github.com/fish-shell/fish-shell/archive/refs/tags/4.2.0.tar.gz",
      sha256sum = "29b4b0e152351a3a635d3f6f613c2d315095a7f632f2533d7575c8a9ede486d5",

      # uri ="https://github.com/fish-shell/fish-shell/archive/refs/tags/4.9.3.tar.gz",
      # sha256sum = "9aac04d7be06e9f7bb41c9162e8804857cadbfbfcb4012fb3d4f591fc19b25be",
    },
    nonCrateSourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/fish-shell/rust-pcre2/archive/refs/tags/0.2.9-utf32.tar.gz",
          sha256sum = "e5af06d7b737b66f7476a223e8a6cd1e2b1ca834b38b3de58901d4dbcf0a054d",
        },
        dest = "vendor/pcre2"
      },
    ],
    options = {
      cmake | default = false,
    },
    crates = lib.functions.filterCrates (import "fish-4.2.0-crates.json"),
    # crates = lib.functions.filterCrates (import "fish-4.9.3-crates.json"),

    configurePhase = [
      # m%"
      #   echo "
      #   [source.\"git+https://github.com/fish-shell/rust-pcre2?tag=0.2.9-utf32#85b7afba\"]
      #   git = \"https://github.com/fish-shell/rust-pcre2\"
      #   replace-with = \"vendored-sources\"
      #   " >> ${SRC}/.cargo/config.toml
      # "%,
      m%"
      echo '
      [source."git+https://github.com/fish-shell/rust-pcre2?tag=0.2.9-utf32"]
      git = "https://github.com/fish-shell/rust-pcre2"
      tag = "0.2.9-utf32"
      replace-with = "vendored-sources"
      ' >> ${SRC}/.cargo/config.toml
      "%,
      "mv ${SRC}/vendor/pcre2/pcre2-sys ${SRC}/vendor/pcre2-sys",
      "cp ${SRC}/vendor/fnv-1.0.7/.cargo-checksum.json ${SRC}/vendor/pcre2",
      "cp ${SRC}/vendor/fnv-1.0.7/.cargo-checksum.json ${SRC}/vendor/pcre2-sys",
      "export FISH_BUILD_VERSION='4.2.0'",
      # "export FISH_BUILD_VERSION='4.9.3'",
      "export CARGO_NET_OFFLINE=1",
      "export CARGO_TERM_VERBOSE=true",
    ],
    postInstallPhase = [
      "install -dm0755 ${DEST}/usr/share",
      "cp -r share/functions ${DEST}/usr/share/functions",
      "cp -r share/completions ${DEST}/usr/share/completions",
    ],

    biDrvs =
      [
        drvs.pcre2cmake,
        (drvs.musl & { priority = 1 }),
        drvs.gettext,

        # drvs.pythonFull,
        # drvs.pythonSetuptools,
        # drvs.pythonInstaller,
        # drvs.pythonGpep517,
        # drvs.pythonFlitCore312,
        # drvs.pythonHatchling,
        # drvs.pythonPathspec,
        # drvs.pythonPluggy,
        # drvs.pythonImportlibMetadate,
        # drvs.pythonMako,
        # drvs.pythonPackaging,
        # drvs.pythonMarkupsafe,
        # drvs.pythonTroveClassifiers,
        # drvs.pythonSphinx,
        # drvs.pythonBabel,
        # drvs.pythonJinja2,
        # drvs.pythonPygments,
        # drvs.pythonSnowballstemmer,
        # drvs.docutils,
      ]
      @ (
        if options.cmake then
          [
            # drvs.samurai,
            drvs.cmake,
            drvs.gnumake,
          ]
        else
          []
      )
  },

  fish4Cmake =
    fish4
    & {
      options.cmake = true,
      enableSccache = false,

      preBuildPhase = [
        "export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)",
        # "export CMAKE_GENERATOR=Ninja",
        "cd ../build",
        m%"
        cmake -B . -S ${SRC} -DBUILD_SHARED_LIBS:BOOL=OFF \
          -DBUILD_STATIC_LIBS:BOOL=ON \
          -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_INSTALL_BINDIR:PATH=bin \
          -DCMAKE_INSTALL_DATAROOTDIR:PATH=share \
          -DCMAKE_INSTALL_INCLUDEDIR:PATH=include \
          -DCMAKE_INSTALL_LIBDIR:PATH=lib \
          -DCMAKE_INSTALL_LIBEXECDIR:PATH=libexec \
          -DCMAKE_INSTALL_LOCALSTATEDIR:PATH=/var \
          -DCMAKE_INSTALL_PREFIX=/usr \
          -DCMAKE_INSTALL_SBINDIR:PATH=bin \
          -DCMAKE_INSTALL_SHAREDSTATEDIR:PATH=../com \
          -DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc \
          -DCMAKE_LINK_SEARCH_START_STATIC:BOOL=OFF \
          -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON \
          -DFISH_USE_SYSTEM_PCRE2:BOOL=ON \
          -DRust_CARGO_TARGET="x86_64-unknown-linux-musl" 
        "%
      ],

      buildPhase = [
        "export CMAKE_MESSAGE_LOG_LEVEL=DEBUG",
        "cmake --build .",
        "echo 'build done'"
      ],
      installPhase = [
        "DESTDIR=${DEST} cmake --install .",
      ],
      postInstallPhase | priority 1 = []
    }
}
