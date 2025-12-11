{
  lib,
  drvs,
  _CargoFetcher,
  _cosmicSrcSha256sums,
  cosmicStoreSources | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = {
        uri = "https://github.com/pop-os/cosmic-store/archive/refs/tags/epoch-1.0.0.tar.gz",
        sha256sum = _cosmicSrcSha256sums."%{uri}", #"aca86d79475738c9d4d55a7d51108d8d64eec530f6c33c68e63b2b3655d8ba45"
      },
      outputSha256sum = (import "src.sha256sum" as 'Text), # "62ba42991eb3a9ca990d19ccc127d07c342796c871dc85a4a93717d0a0a7cecd"
    },
}
& {
  lib,
  drvs,
  cosmicStore | lib.CargoPackage = {

    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "export CARGO_HOME=${SRC}/.cargo",
      m%"sed -i 's/\("files":{\)[^}]*/\1/' vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer/Cargo.toml"%,
    ],
    extraEnv = {

      # cosmic-epoch alpha
      VERGEN_GIT_COMMIT_DATE = "9e13a3e47a41296e815ecffef086746dd6bb44bc",
      VERGEN_GIT_SHA = "'Sat Apr 26 13:09:25 2025 +0530'",
    },

    patches = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
    ],
    target,

    extraEnv.EXTRA_RUSTFLAGS =
      [
        "-C link-arg=-lassuan",
        "-C link-arg=-lgpg-error",
        "-C link-arg=-lgpgme",
        "-C link-arg=-lz",
        "-C link-arg=-llz4",
        "-C link-arg=-lzstd",
        "-C link-arg=-llzma",
      ]
      @ (
        std.array.map
          (fun x => "-C link-arg=%{x}")
          (std.string.split " " "-lflatpak -lgpgme -lgpg-error -lassuan -lgpg-error -ljson-glib-1.0 -pthread -lpcre2-8 -lz -larchive -llz4 -lcurl -lpsl -lssl -lcrypto -lz -lcrypto -lz -lssl -ldl -pthread -lcrypto -ldl -pthread -lpsl -lssl -lcrypto -ldl -pthread -lcrypto -ldl -lpsl -lostree-1 -lgio-2.0 -lgobject-2.0 -lffi -lgmodule-2.0 -lglib-2.0 -lpcre2-8 -lz -lxml2 -lm -lzstd -pthread")
      ),
    # buildPhase = [
    #   "just args=\" --target %{target}\" build-vendored "
    # ],

    installPhase = [
      "export CARGO_TARGET_DIR=\"target/%{target}\"",
      "just rootdir=$DEST install",
    ],

    postInstallPhase = [
      "cargo tree --target=x86_64-unknown-linux-musl -e features > features_manifest.txt",
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
    llvmProvider,
    # llvmProvider = drvs.llvmFull,

    enableSccache = true,
    biDrvs = [
      (drvs.findutils & { priority = 1 }), # xargs -d
      drvs.just,
      drvs.cosmicStoreSources,
      drvs.atSpi2Core,
      drvs.cairo,
      drvs.cairoGobjectEmpty,
      drvs.dbus,
      drvs.eudev,
      drvs.expat,
      drvs.fontconfig,
      drvs.freetype,
      drvs.fribidi,
      drvs.glib,
      drvs.gperf,
      drvs.jansson,
      drvs.libffi,
      drvs.libusb,
      drvs.libxkbcommon,
      drvs.libyaml,
      drvs.linuxHeaders,
      drvs.openssl,
      drvs.pcre2,
      drvs.pixman,
      drvs.utilLinux,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.xz,
      drvs.zlibNg,
      drvs.zstd,
      drvs.libstdcppCompat,
      drvs.flatpak,
      drvs.curl,
      drvs.libcap,
      drvs.libarchive,
      drvs.libpsl,
      drvs.libxml2,
      drvs.fuse,
      drvs.ostree,
      drvs.jsonGlib,
      drvs.appstream,
      drvs.libxmlb,
      drvs.libassuan,
      drvs.libgpgError,
      drvs.gpgme,
      drvs.lz4,
      drvs.bubblewrap,
      drvs.xdgDbusProxy,
    ],
  },
}
