{
  lib,
  drvs,
  _CargoFetcher,
  rustdeskSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        # uri = "https://github.com/rustdesk/rustdesk/archive/refs/tags/1.4.8.tar.gz",
        # sha256sum = "ab424b48861cb74ca84e847564ca071a7c7a393a2ab3818a8d0a095e290caa85",

        # uri = "https://github.com/rustdesk/rustdesk.git",
        # sha256sum = "3c574a41821170f89f38141a493e127145dbf82d",
        # fetchMethod = "git",

        uri = "https://github.com/rustdesk/rustdesk/archive/d412d198720aa56f6cfed2dfad262e8fb1322fb7.tar.gz",
        sha256sum = "e6bdb1e565ffa4a28228522e42046df40fd79b75fb58e286d54c4ad0a7dc2c26",
      },
      sourceInputs = [
        {
          src = singleSource
        },
        {
          src = {
            uri = "https://github.com/rustdesk/hbb_common/archive/387603f47cbb15c0d3dc3d67ae3396d3eb707daf.tar.gz",
            sha256sum = "8b2155e81c1fcdeaca6c02a0ed88af7701b2e07f513b8bba8a62ab1e0053672d"
          },
          dest = "libs/hbb_common"
        },
      ],
      outputFile | priority 1 = "vendor.tar",
      # outputSha256sum = "a4adb64c04f572d485e7bc9e2009f3efc56af6692093e9494addf64f6240c5ac",
      # outputSha256sum = "50ebf094d083660d675868ab0c5c9eda29f2bd23f911510e8b6e3761dc445603",
      # outputSha256sum = "d98292a3a5dafa88d38b7651a0f9f36bfdc73e98138fcb2655043e07ef30ddc5",
      outputSha256sum = "2c3024a401d91ce943325f616ae23a45f9927cba394f76336cc4d14e8dfa7660",

      preConfigurePhase = [
        # "(cd ${SRC} && git submodule update --init --recursive)",
        # lib.functions.writeFile "Cargo.lock" (import "Cargo.lock" as 'Text),
        "cargo metadata --offline --no-deps",
      ],
      buildPhase | priority 1 = [
        "mkdir -p $HOME",
        "mkdir -p .cargo",
        # "cargo vendor --locked >> .cargo/config.toml",
        "cargo vendor-filterer --platform=x86_64-unknown-linux-musl --prefix=vendor --format=tar",
        "cp vendor.tar ../out/destdir",
        # "cargo vendor-filterer  --platform=x86_64-unknown-linux-musl >> .cargo/config.toml",

        #   "tar --sort=name --format=ustar --mtime='2015-10-21 00:00Z' -cf ../build/%{outputFile} .",
        # m%"find . -exec touch --no-dereference --date="@1302044400" {} +"%,
        # "rm -rv ./libs/hbb_common/.git",
        # "rm -rv ./.git",
        # "find . -print0 | sort -z | bsdtar --null -T - --format=pax --mtime='2015-10-21 00:00Z' -cf ../out/destdir/%{outputFile} .",
      ],
      installPhase | priority 1 = [],
      biDrvs | priority 1 =
        _CargoFetcher.biDrvs
        @ [
          drvs.gnutar & { priority = 1 },
          drvs.libarchive,
          # drvs.cargoVendorFilter,
        ],
    },

  rustdesk | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/rustdesk/rustdesk/archive/d412d198720aa56f6cfed2dfad262e8fb1322fb7.tar.gz",
      sha256sum = "e6bdb1e565ffa4a28228522e42046df40fd79b75fb58e286d54c4ad0a7dc2c26",

      # uri = "https://github.com/rustdesk/rustdesk.git",
      # sha256sum = "3c574a41821170f89f38141a493e127145dbf82d",
      # fetchMethod = "git",
    },
    sourceInputs = [
      {
        src = singleSource
      },
      {
        src = {
          uri = "https://github.com/rustdesk/hbb_common/archive/69cea8dafee147848ae88702029f4bf7df7224c3.tar.gz",
          sha256sum = "f5e33a2e813c8bfb0ea37b0807ae4289caeb9fa41b566669d39e7cc5ad58e4c8"
        },
        dest = "libs/hbb_common"
      },
    ],

    # unpackPhase = [
    #   "cd /tmp/workdir/src",
    #   "tar xf /vendor.tar",
    # ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        # "-C link-arg=-lepoxy",
        "-C link-arg=-lc++",
        # m%"$(for l in $(pkg-config --libs --static epoxy wayland-client wayland-egl cairo xcursor atk-bridge-2.0 gtk+-3.0 gtk+-wayland-3.0 gtk+-x11-3.0 libpulse gstreamer-full-1.0);do printf " -C link-arg=$l ";done)"%,
      ],

      PKG_CONFIG_PATH = "\"/usr/lib/pkgconfig:/usr/lib/gstreamer-1.0/pkgconfig\"",
    },

    extraCargoFlags = [
      "--features linux-pkg-config",
    ],
    preConfigurePhase = [
      m%"TMP="$(for l in $(pkg-config --libs --static epoxy wayland-client wayland-egl cairo xcursor atk-bridge-2.0 gtk+-3.0 gtk+-wayland-3.0 gtk+-x11-3.0 libpulse gstreamer-full-1.0 gsthip);do printf " -C link-arg=$l ";done)""%,
      m%"export RUSTFLAGS="${RUSTFLAGS} ${TMP}""%,
      m%"export RUSTFLAGS="${RUSTFLAGS} -C link-arg=/usr/lib/gstreamer-1.0/libgsthip.a""%,
      "export CARGO_HOME=${SRC}/.cargo",
      "export OPENSSL_NO_VENDOR=1",
      "export SODIUM_USE_PKG_CONFIG=1",
      "cat >> .cargo/config.toml << 'EOF'\n%{import "config.toml" as 'Text}\n\nEOF\n",
      #lib.functions.writeFile "Cargo.lock" (import "Cargo.lock" as 'Text),
      #lib.functions.writeFile "libs/hbb_common/Cargo.lock" (import "hbb_common_Cargo.lock" as 'Text),
      "tar xf /vendor.tar",
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/kcp-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys*/build.rs"%,
      m%"sed -i 's@libpulse-simple.so.0@libpulse-simple.a@g' ${SRC}/vendor/libpulse-simple-sys*/build.rs"%,
      "cargo metadata --offline --no-deps",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      "cargo tree --target=x86_64-unknown-linux-musl %{std.string.join " " extraCargoFlags } -e features",
    ],

    llvmProvider = drvs.llvmFull,
    rustProvider = drvs.rustWFmt,

    biDrvs = [
      drvs.rustdeskSources,
      drvs.llvmConfigStatic,
      drvs.libstdcppCompat,
      # drvs.rustfmt,
    ],
    neverInclude = [
      drvs.cairo,
      drvs.libepoxy,
      drvs.cairoGobject,
    ],
    pDrvs =
      [
        # drvs.openssl,
        drvs.gstreamer,
        # drvs.libxi,
        drvs.libxtst,
        drvs.libsodium,
        drvs.ncurses,
        drvs.libpam,
      ]
      @ [
        drvs.gtk3X11,
        drvs.gdkPixbufFull,
        # drvs.harfbuzzFull,
        drvs.atSpi2Core,
        drvs.graphene,
        drvs.libxkbcommon,
        drvs.pango,
        drvs.libtiff,
        drvs.libepoxyX11,
        # drvs.gobjectDynamic,
        # drvs.cairoGobject,
        drvs.libxrandr,
        # drvs.libxcursor,
        drvs.cairoXlib,
        drvs.libyuv,
        drvs.libopus,
        drvs.libvpx,
        drvs.libaom,
        # drvs.libgit2,
        drvs.pulseaudio17,
      ],
  }
}
