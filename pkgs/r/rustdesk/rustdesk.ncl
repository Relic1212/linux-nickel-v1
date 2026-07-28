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

        uri = "https://github.com/rustdesk/rustdesk.git",
        sha256sum = "3c574a41821170f89f38141a493e127145dbf82d",
        fetchMethod = "git",
      },
      sourceInputs = [
        {
          src = singleSource
        },
        # {
        #   src = {
        #     uri = "https://github.com/rustdesk/hbb_common/archive/refs/tags/driver.tar.gz",
        #     sha256sum = "5d2f4909f5569231690d7446ac962a932e7e7f55ddee34ba01dcf43908bc3d7d"
        #   },
        #   dest = "libs/hbb_common"
        # },
      ],
      outputFile | priority 1 = "vendor.tar",
      # outputSha256sum = "a4adb64c04f572d485e7bc9e2009f3efc56af6692093e9494addf64f6240c5ac",
      # outputSha256sum = "50ebf094d083660d675868ab0c5c9eda29f2bd23f911510e8b6e3761dc445603",
      outputSha256sum = "d98292a3a5dafa88d38b7651a0f9f36bfdc73e98138fcb2655043e07ef30ddc5",

      preConfigurePhase = [
        "(cd ${SRC} && git submodule update --init --recursive)",
        # lib.functions.writeFile "Cargo.lock" (import "Cargo.lock" as 'Text),
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
      uri = "https://github.com/rustdesk/rustdesk/archive/refs/tags/1.4.8.tar.gz",
      sha256sum = "ab424b48861cb74ca84e847564ca071a7c7a393a2ab3818a8d0a095e290caa85",

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
          uri = "https://github.com/rustdesk/hbb_common/archive/387603f47cbb15c0d3dc3d67ae3396d3eb707daf.tar.gz",
          sha256sum = "8b2155e81c1fcdeaca6c02a0ed88af7701b2e07f513b8bba8a62ab1e0053672d"
        },
        dest = "libs/hbb_common"
      },
    ],

    # unpackPhase = [
    #   "cd /tmp/workdir/src",
    #   "tar xf /vendor.tar",
    # ],

    extraCargoFlags = [
      "--features linux-pkg-config",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      "export OPENSSL_NO_VENDOR=1",
      "export SODIUM_USE_PKG_CONFIG=1",
      "cat >> .cargo/config.toml << 'EOF'\n%{import "config.toml" as 'Text}\n\nEOF\n",
      #lib.functions.writeFile "Cargo.lock" (import "Cargo.lock" as 'Text),
      #lib.functions.writeFile "libs/hbb_common/Cargo.lock" (import "hbb_common_Cargo.lock" as 'Text),
      "tar xf /vendor.tar",
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/kcp-sys*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys*/Cargo.toml"%,
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
        drvs.libepoxy,
        # drvs.gobjectDynamic,
        drvs.cairoGobject,
        drvs.libxrandr,
        # drvs.libxcursor,
        drvs.cairoXlib,
        drvs.libyuv,
        drvs.libopus,
        drvs.libvpx,
        drvs.libaom,
        # drvs.libgit2,
      ],
  }
}
