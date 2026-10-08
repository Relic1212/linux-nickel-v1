{
  lib,
  drvs,
  distro,
  cosmicComp | lib.CargoPackage = {
    # sourceInputs = [
    #   {
    #     src = {
    #       uri = "https://github.com/pop-os/cosmic-comp/commit/dc983e7ee4201040e0f58fdbe96be1afcbdf7312.patch",
    #       sha256sum = "370435f120c904c002af256554085b788e32cd9ecc51ddec7ddb6ab0a05fc835"
    #     }
    #   },
    # ],

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /cosmic-comp-sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      # "(cd ${SRC} && patch -p1 < ../packed/370435f120c904c002af256554085b788e32cd9ecc51ddec7ddb6ab0a05fc835/dc983e7ee4201040e0f58fdbe96be1afcbdf7312.patch)",

      # "sed -i 's|2024|2021|g' ${SRC}/Cargo.toml",
      "sed -i 's|extern|unsafe extern|g' ${SRC}/vendor/gl_generator/generators/static_gen.rs",
      "sed -i 's|extern|unsafe extern|g' ${SRC}/vendor/gl_generator/generators/static_struct_gen.rs",
    ],

    extraEnv = {
      # https://github.com/NixOS/nixpkgs/pull/264517#issuecomment-1817817060
      EXTRA_RUSTFLAGS =
        [
          "-C link-arg=-Wl,--push-state,--no-as-needed",
          "-C link-arg=-lc++",

          # pkg-config --libs --static libinput
          "-C link-arg=-linput",
          "-C link-arg=-lm",
          "-C link-arg=-ludev",
          "-C link-arg=-pthread",
          "-C link-arg=-levdev",
          "-C link-arg=-lrt",
          "-C link-arg=-lmtdev",
          # input
          "-C link-arg=$(clang --print-file-name=libclang_rt.builtins-x86_64.a)",
          m%"$(for l in $(pkg-config --libs --static egl);do printf " -C link-arg=$l ";done)"%,
        ]
        @ (if distro.pam then ["-lcap"] else [])
        @ [
          "-C link-arg=-Wl,--pop-state",
        ],
    },

    eofPatches = [
      {
        patch = import "static-gl.patch" as 'Text,
        subdir = "/vendor",
      },
      {
        patch = import "ffi.patch" as 'Text,
        subdir = "/vendor",
      },
      # {
      #   sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
      #   file = "cosmic-osd-xkb.patch",
      # }
    ],

    # release = false,

    # default = systemd
    extraCargoFlags = [
      "--no-default-features",
      "--features logind",
    ],

    cargoFlags,
    target,

    buildPhase = [
      # "make ARGS+=\"%{std.string.join " " cargoFlags}\"",
      # "just build-release --offline --target x86_64-unknown-linux-musl",
      # "just args=\"%{std.string.join " " cargoFlags }\" build-release",
      "just build-release %{std.string.join " " (std.array.drop_first cargoFlags) }",
    ],
    installPhase = [
      # "make TARGET=\"%{target}/release\" DESTDIR=$DEST install",
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      # "just --set bin-src \"target/%{target}/%{d}/cosmic-settings\" rootdir=$DEST install",
      "just rootdir=$DEST install",
    ],

    # buildPhase = [
    #   "make ARGS+=\"%{std.string.join " " cargoFlags}\"",
    # ],
    # installPhase = [
    #   "make TARGET=%{target}/release DESTDIR=$DEST install",
    # ],
    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features",
    ],

    utilsProviders,
    baseBuildinputPackages =
      [
        drvs.rust,
        drvs.muslBoth,
        drvs.pkgconf,
        llvmProvider,
        drvs.clangCc,
      ]
      @ (if enableSccache then [drvs.sccache] else [])
      @ utilsProviders,
    llvmProvider = drvs.llvmFull,

    enableSccache = true,
    biDrvs = [
      drvs.just,
      drvs.cosmicCompSources,
      drvs.gnupatch & { priority = 1 },
    ],

    pDrvs = [
      drvs.mesa2,
      # drvs.eudev,
      drvs.seatd,
      drvs.libdisplayinfo,
      drvs.libxkbcommon,
      drvs.libinput,
      drvs.pixman,
    ],
  },

  _testFetcher | lib.DeterministicFetcher = {
    buildPhase = [
      "wget https://github.com/pop-os/cosmic-comp/archive/refs/tags/epoch-1.0.0.tar.gz",
      "cp epoch-1.0.0.tar.gz ${DEST}/out.tar.gz",
    ],
    outputFile = "out.tar.gz",
    outputSha256sum = (import "src.sha256sum" as 'Text), # "7bd9f19a69fb9708448d0a551d2c8bf5abf809457694f17aefd8d4d03b70d16d",
    biDrvs = [
      drvs.emptyResolvConf
    ]
  },
  emptyResolvConf | lib.Package = {
    installPhase = [
      "install -d -m0755 ${DEST}/etc",
      "touch ${DEST}/etc/resolv.conf",
    ]
  }
}
& {
  lib,
  drvs,
  _cosmicSrcs,
  _cosmicSrcs,

  cosmicCompSources | lib.DeterministicFetcher = {
    singleSource = _cosmicSrcs."cosmic-comp",

    extraEnv = {
      HOME = "/tmp/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      "cargo vendor --locked >> .cargo/config.toml",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    outputSha256sum = (import "src.sha256sum" as 'Text),
    outputFile = "cosmic-comp-sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      # drsv.gnutar & {priority = 1},
    ]
  }
}
& {
  lib,
  drvs,
  _CargoFetcher | lib.DeterministicFetcher = {
    options = {
      vendorFilter | default = false,
    },

    extraEnv = {
      HOME = "/tmp/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      (
        if (!options.vendorFilter) then
          "cargo vendor --locked >> .cargo/config.toml"
        else
          "cargo vendor-filterer  --platform=x86_64-unknown-linux-musl >> .cargo/config.toml"
      ),
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "tar cf - . > ../build/%{outputFile}",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "3ae4cb26d9fff4c7154b68bcbfedb84b9cc14cf5b85bfec71bd4239ef22bedcf",
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "163454290382acc2c491376355c67f93cdb72e1a2fe2056f21c0d4a41f8a1821",

    outputFile = "sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      drvs.cargoVendorFilter,
      # drsv.findutils & {priority = 1},
      # drsv.gnutar & {priority = 1},
    ]
  },

  _CargoCacher | lib.DeterministicFetcher = {

    extraEnv = {
      HOME = "/tmp/workdir/src/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      # "cargo vendor --locked >> .cargo/config.toml",
      "cargo fetch --locked",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      # m%"find . -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      # "rm -rf ./home/.cargo/git/checkouts/*/*/.git",
      # "rm -rf ./home/.cargo/git/checkouts/*/*/*/.git"
      "for d in $(find ./home -name '.git' -type d); do rm -rf $d; done",
      "rm -f ./home/.cargo/.global-cache",
      # "tar cf - . > ../build/%{outputFile}",
      "tar --sort=name --format=ustar --mtime='2015-10-21 00:00Z' -cf ../build/%{outputFile} .",
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "3ae4cb26d9fff4c7154b68bcbfedb84b9cc14cf5b85bfec71bd4239ef22bedcf",
    # outputSha256sum = (import "src.sha256sum" as 'Text), # "163454290382acc2c491376355c67f93cdb72e1a2fe2056f21c0d4a41f8a1821",

    outputFile = "sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      drvs.gnutar & { priority = 1 },
    ]
  }
}
& ({ _cosmicSrcs = (import "../cosmic-common/_cosmic_sources.ncl") & (import "../cosmic-common/_cosmic_sources_override.ncl") }
)
