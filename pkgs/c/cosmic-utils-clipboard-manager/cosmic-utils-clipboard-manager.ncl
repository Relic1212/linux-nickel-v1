{
  lib,
  drvs,
  cosmicUtilsClipboardManager1 | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/cosmic-utils/clipboard-manager/archive/f74b562a09e88e8d20ee0b9c5ab8cade8e4edbdb.tar.gz",
      sha256sum = "56879774d884410c8075051d52d8e0c92c54139976a37c68c795696664b4f0cb"
    },
    crates = lib.functions.filterCrates (import "cosmic-utils-clipboard-manager-crates.json"),
    nonCrateSourceInputs = [{ src = singleSource }, ] @ (import "src.ncl"),
    # Updating git repository `https://github.com/pop-os/libcosmic`
    # Updating git submodule `https://github.com/pop-os/iced.git`
    # Updating git repository `https://github.com/pop-os/cosmic-protocols`
    # Updating git repository `https://github.com/pop-os/cosmic-panel`
    # Updating git repository `https://github.com/pop-os/dbus-settings-bindings`
    # Updating git repository `https://github.com/pop-os/freedesktop-icons`
    # Updating git repository `https://github.com/jackpot51/rust-atomicwrites`
    # Updating git repository `https://github.com/pop-os/window_clipboard.git`
    # Updating git repository `https://github.com/pop-os/cosmic-text.git`
    # Updating git repository `https://github.com/pop-os/softbuffer`
    # Updating git repository `https://github.com/pop-os/winit.git`
    # Updating git repository `https://github.com/pop-os/smithay-clipboard`
    # Updating git repository `https://github.com/wash2/accesskit`
    # Updating git repository `https://github.com/pop-os/glyphon.git`

    configurePhase = [
      m%"echo '
[source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/jackpot51/rust-atomicwrites"]
git = "https://github.com/jackpot51/rust-atomicwrites"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-panel"]
git = "https://github.com/pop-os/cosmic-panel"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-protocols?rev=d0e95be"]
git = "https://github.com/pop-os/cosmic-protocols"
rev = "d0e95be"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-text.git"]
git = "https://github.com/pop-os/cosmic-text.git"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/dbus-settings-bindings"]
git = "https://github.com/pop-os/dbus-settings-bindings"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/freedesktop-icons"]
git = "https://github.com/pop-os/freedesktop-icons"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/glyphon.git?tag=iced-0.14-dev"]
git = "https://github.com/pop-os/glyphon.git"
tag = "iced-0.14-dev"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/libcosmic"]
git = "https://github.com/pop-os/libcosmic"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/smithay-clipboard?tag=pop-dnd-5"]
git = "https://github.com/pop-os/smithay-clipboard"
tag = "pop-dnd-5"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/softbuffer?tag=cosmic-4.0"]
git = "https://github.com/pop-os/softbuffer"
tag = "cosmic-4.0"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/window_clipboard.git?tag=pop-0.13-2"]
git = "https://github.com/pop-os/window_clipboard.git"
tag = "pop-0.13-2"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/winit.git?tag=iced-xdg-surface-0.13-rc"]
git = "https://github.com/pop-os/winit.git"
tag = "iced-xdg-surface-0.13-rc"
replace-with = "vendored-sources"

[source."git+https://github.com/wash2/accesskit?tag=iced-xdg-surface-0.13-rc"]
git = "https://github.com/wash2/accesskit"
tag = "iced-xdg-surface-0.13-rc"
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"      
      ' > .cargo/config.toml"%,
      "(cd vendor-accesskit/common && cargo package --exclude-lockfile -p accesskit --no-verify)",
      # "cp -r vendor-accesskit/common vendor/accesskit",
      "mkdir vendor/accesskit",
      "cp -r vendor-accesskit/target/package/accesskit-0.16.0.crate vendor/accesskit/accesskit.tar.gz",
      "(cd vendor/accesskit && tar xf accesskit.tar.gz)",
      m%"(cd vendor && for d in $(ls); do if [ -d ${d} ];then if [ ! -e ${d}/.cargo-checksum.json ];then echo '{"files":{},"package":null}' > ${d}/.cargo-checksum.json;fi;fi;done)"%,

      # "(cd vendor-dbus-settings-bindings/common && cargo package --exclude-lockfile -p --no-verify)",
    ]
  },
  _CargoFetcher,
  cosmicUtilsClipboardManagerSrc | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = cosmicUtilsClipboardManager1.singleSource,
      outputSha256sum = "4e34855e27db67c68a1710cf3ce8cb4641d9a1d3681b24e9e905f05137972860",
    },

  cosmicUtilsClipboardManager | lib.CargoPackage = {
    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    patches = [
      {
        sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
        file = "cosmic-osd-xkb.patch",
      }
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
    postInstallPhase =
      let appid = "io.github.cosmic_utils.cosmic-ext-applet-clipboard-manager" in
      [
        "install -dm0755 ${DEST}/usr/share/applications",
        "install -dm0755 ${DEST}/usr/share/metainfo",
        "install -dm0755 ${DEST}/usr/share/icons/hicolor/scalable/apps",
        "install -dm0755 ${DEST}/usr/share/configurator",
        "install -m0755 res/desktop_entry.desktop ${DEST}/usr/share/applications/%{appid}.desktop",
        "install -m0755 res/metainfo.xml ${DEST}/usr/share/metainfo/%{appid}.metainfo.xml",
        "install -m0755 res/app_icon.svg ${DEST}/usr/share/icons/hicolor/scalable/apps/%{appid}-symbolic.svg",
        "install -m0755 res/config_schema.json ${DEST}/usr/share/configurator/%{appid}.json",
        "echo MANIFEST:",
        "cargo tree  --target x86_64-unknown-linux-musl -e features",
      ],
    biDrvs = [
      drvs.cosmicUtilsClipboardManagerSrc,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
    ],
  }
}
