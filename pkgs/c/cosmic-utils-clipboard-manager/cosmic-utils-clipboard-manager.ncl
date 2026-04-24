{
  lib,
  drvs,
  _cosmicUtilsClipboardManager | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/cosmic-utils/clipboard-manager/archive/d473e8f09e8bc2289a76707898063a13714c79dc.tar.gz",
      sha256sum = "f5fb03d958a9d45ae7ccf3c45456b32528a6e366d0b5fc25afe34a11f775292f"
    },
  },
  _CargoFetcher,
  cosmicUtilsClipboardManagerSrc | lib.DeterministicFetcher =
    _CargoFetcher
    & {
      singleSource = _cosmicUtilsClipboardManager.singleSource,
      outputSha256sum = "0fa6e24827daa32d654783a1ab993abf26885d5467f82aaa5cf8460b4b3fb546",
    },

  cosmicUtilsClipboardManager | lib.CargoPackage = {
    unpackPhase = [
      "cd /tmp/workdir/src",
      "tar xf /sources.tar",
    ],
    # patches = [
    #   {
    #     sha256sum = "ae7010ae3fd4b4603789a9cb58e5fd40bea31b728bed9fd112c581c039d39527",
    #     file = "cosmic-osd-xkb.patch",
    #   }
    # ],

    extraEnv = {
      EXTRA_RUSTFLAGS = [
        "-C link-arg=/tmp/workdir/src/dlopen.o",
        m%"$(for l in $(pkg-config --libs --static xkbcommon);do printf " -C link-arg=$l ";done)"%,
      ],
    },

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
      m%"sed -i 's@"softbuffer/wayland-dlopen",@@g' ${SRC}/vendor/iced_tiny_skia/Cargo.toml"%,
      "echo '%{import "../cosmic-osk/cosmic_osk_dlopen.c" as 'Text}' > ${SRC}/dlopen.c",
      "${CC} ${CFLAGS} -c ${SRC}/dlopen.c -o ${SRC}/dlopen.o",
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
    muslProvider = drvs.muslBothRenamedDl,
    biDrvs = [
      drvs.cosmicUtilsClipboardManagerSrc,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
    ],
  }
}
