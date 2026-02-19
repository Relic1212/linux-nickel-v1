{
  lib,
  drvs,
  _cosmicEpochSources | lib.DeterministicFetcher = {
    # singleSource = {
    #   fetchMethod = "git",
    #   uri = "https://github.com/pop-os/cosmic-epoch.git",
    #   sha256sum = "d955da69d4fa843c18a186a48e80731324a04beb"
    # },
    outputSha256sum = (import "src.sha256sum" as 'Text),
    extraEnv = {
      HOME = "${BUILDDIR}/home"
    },
    separateBuildDir = false,
    buildPhase = [
      "git clone --recursive --depth=1 -b epoch-1.0.5 https://github.com/pop-os/cosmic-epoch.git",
      "cd cosmic-epoch",
      "mkdir -p $HOME",
      "mkdir -p .cargo",
      "export CARGO_HOME=${HOME}/.cargo",

      #   "git submodule init",
      "for d in $(ls); do",
      " if [ -e ${d}/Cargo.toml ]; then",
      "   echo \"fetching for ${d}\"",
      "  (cd ${d} && mkdir -p .cargo)",
      "  (cd ${d} && cargo vendor --locked ./vendor >> .cargo/config.toml)",
      "break",
      " fi",
      "done",
      "rm -rf .git",

      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find .. -exec touch --no-dereference --date="@1302044400" {} +"%,
      # "rm -rf .git",
      # "tar --sort=name --format=ustar --mtime='2015-10-21 00:00Z' -cf ../../build/%{outputFile} .",
      # "bsdtar c -m --no-same-permissions -o -f ../../build/%{outputFile} $(find . | sort)",
      "find . -print0 | sort -z | bsdtar --null -T - --format=pax --mtime='2015-10-21 00:00Z' -cf ../../build/%{outputFile} .",
      "cd .."
    ],
    installPhase = [
      "cp ../build/%{outputFile} ${DEST}",
    ],

    outputFile = "sources.tar",

    biDrvs = [
      drvs.emptyResolvConf,
      drvs.muslShared,
      drvs.rust,
      drvs.gitFull,
      drvs.caCertificates,
      # drsv.findutils & {priority = 1},
      # drvs.gnutar & { priority = 1 },
      drvs.libarchive & { priority = -1 },
    ],
  },

  _cosmicEpoch | lib.CargoPackage = {
    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    preConfigurePhase = [
      "%{import "build.sh" as 'Text}",
      "export CARGO_HOME=${SRC}/.cargo",
      "mkdir /tmp/workdir/build/home",
      "export HOME=/tmp/workdir/build/home",
      # m%"sed -i 's/\("files":{\)[^}]*/\1/' ${SRC}/vendor/*/.cargo-checksum.json"%,
      m%"sed -i 's@"clang-sys\/runtime"@"clang-sys\/static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/iced_wgpu-*/Cargo.toml"%,
      m%"sed -i 's@"dlopen",@@g' ${SRC}/vendor/smithay-clipboard-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static","libcpp"@g' ${SRC}/vendor/clang-sys-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/bindgen-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/libspa-sys-*/Cargo.toml"%,
      m%"sed -i 's@"runtime"@"static"@g' ${SRC}/vendor/pipewire-sys-*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/accesskit_winit-*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/iced_winit-*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/softbuffer-*/Cargo.toml"%,
      m%"sed -i 's@"wayland-dlopen",@@g' ${SRC}/vendor/winit-*/Cargo.toml"%,
      m%"sed -i 's@\["dlopen"\]@\[\]@g' ${SRC}/vendor/iced_wgpu-*/Cargo.toml"%,
      m%"sed -i 's@default-features = false@default-features = false\nfeatures = \[ \"static\" \]@g' ${SRC}/vendor/pam-sys-*/Cargo.toml"%,
      m%"sed -i 's@libpulse.so.0@libpulse.a@g' ${SRC}/vendor/libpulse-sys-*/Cargo.toml"%,
      # m%"sed -i 's|/bin/bash|/usr/bin/bash|g' ${DEST}/usr/bin/start-cosmic#!/bin/sh -e"%,
      # m%"sed -i 's|\/bin\/false|\/usr\/bin\/false|g' ${DEST}/usr/share/dbus-1/services/org.freedesktop.impl.portal.desktop.cosmic.service"%,

      # "patch -p1 < /tmp/workdir/files/cosmic-osd-xkb.patch",
      "echo '%{import "checksum.py" as 'Text}' > checksum.py",
      "for f in $(ls vendor/*/.cargo-checksum.json); do python checksum.py $f; done",
    ],
    extraFiles = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      },
      {
        file = "static-gl.patch",
        sha256sum = "87d04858cb694020f4b6e2354ef2640f4e7f1bac3c933c8b7b2f37d43d59b7b7"
      },
      {
        sha256sum = "9c4fd74ddabfbe7ce1e1cd71c728fc912659185fe5f2ec03905498badfc1afd0",
        file = "ffi.patch"
      },
      {
        sha256sum = "035383fd16604845096ca9306dff0c8e81aa56e2c3a032be86a8767a7355d29c",
        file = "fix-auto.patch"
      },
    ],
    buildPhase = [
      m%"just_build cosmic-applets build-release"%,
      m%"just_build cosmic-applibrary build-release"%,
      m%"just_build cosmic-bg build-release"%,
      m%"just_build cosmic-edit build-release"%,
      m%"just_build cosmic-files build-release"%,
      m%"just_build cosmic-greeter build-release"%,
      m%"just_build cosmic-idle build-release"%,
      m%"just_build cosmic-initial-setup build-release"%,
      m%"just_build cosmic-launcher build-release"%,
      m%"just_build cosmic-notifications build-release"%,
      m%"just_build cosmic-osd build-release"%,
      m%"just_build cosmic-panel build-release"%,
      m%"just_build cosmic-player build-release"%,
      m%"just_build cosmic-randr build-release"%,
      m%"just_build cosmic-screenshot build-release"%,
      m%"just_build cosmic-settings build-release"%,
      m%"just_build cosmic-session build-release"%,
      m%"just_build cosmic-store build-release"%,
      m%"just_build cosmic-term build-release"%,
      m%"just_build pop-launcher build-release"%,
    ],
    enableSccache = false,
    biDrvs = [
      # drvs.cosmicEpochSources,
      drvs.just,
      drvs.gnumake,
      drvs.pythonFull,
    ],
  }
}
