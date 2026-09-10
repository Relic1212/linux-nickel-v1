{
  lib,
  drvs,
  bcvk | lib.CargoPackage = {
    singleSource = {
      uri = "https://github.com/bootc-dev/bcvk/archive/refs/tags/v0.19.0.tar.gz",
      sha256sum = "81877ab8cc02ae5b9275b981d5f0bf4bf762d061782c5c5a62112d9e5dc3f09e",

      # uri = "https://github.com/bootc-dev/bcvk/archive/refs/tags/v0.17.0.tar.gz",
      # sha256sum = "493586c4e326071876265ef8db52d9bd96f6277e4cb4f993a8990a6a5cced705",
    },

    sourceInputs = [
      {
        src = singleSource,
      },
      {
        src = {
          uri = "https://github.com/bootc-dev/bcvk/releases/download/v0.19.0/bcvk-0.19.0-vendor.tar.zstd",
          sha256sum = "c51b51e4ba6ddc44a4dbe07d72fb6bd9e44212a7d179a7066563e985e3f549c3",
          # uri = "https://github.com/bootc-dev/bcvk/releases/download/v0.17.0/bcvk-0.17.0-vendor.tar.zstd",
          # sha256sum = "69bdc8fe0c88e0b01ff39c986aa42c3ad991ab1c0f7d81600a29e7a8e43328d2",
        },
        dest = "vendor"
      }
    ],
    # crates = lib.functions.filterCrates (import "bcvk-crates.json"),

    eofPatches=[
      {
        patch = (import "no-ld-so-cache.patch" as 'Text),
      },
    ],

    preConfigurePhase = [
      lib.functions.writeFile
        ".cargo/config.toml"
        (
          if true then
            m%"
[source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/bootc-dev/bootc?rev=534c76ea474a356aa288f6767635e579ea2614d5"]
git = "https://github.com/bootc-dev/bootc"
rev = "534c76ea474a356aa288f6767635e579ea2614d5"
replace-with = "vendored-sources"

[source."git+https://github.com/bootc-dev/bootc?rev=54768712ee0308c51ccd27e8d7772d9c9f9aad39"]
git = "https://github.com/bootc-dev/bootc"
rev = "54768712ee0308c51ccd27e8d7772d9c9f9aad39"
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"
"%
          else
            m%"
[source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/bootc-dev/bootc?rev=93b22f4dbc2d54f7cca7c1df3ee59fcdec0b2cf1"]
git = "https://github.com/bootc-dev/bootc"
rev = "93b22f4dbc2d54f7cca7c1df3ee59fcdec0b2cf1"
replace-with = "vendored-sources"

[source.vendored-sources]
directory = "vendor"

"%
        ),
      "export CARGO_HOME=${SRC}/.cargo",
      "export OPENSSL_NO_VENDOR=1",
      m%"sed -i 's@VHOST_VSOCK_SET_GUEST_CID,@VHOST_VSOCK_SET_GUEST_CID.try_into().unwrap(),@g' crates/bcvk-qemu/src/qemu.rs"%,
    ],

    ## Neewds go-md2man
    # preInstallPhase = [
    #   "make PREFIX=/usr manpages"
    # ],

    # installPhase = [
    #   "make PREFIX=/usr DESTDIR=${DEST} install",
    # ],

    biDrvs = [
      drvs.gnutar & { priority = 1 },
      drvs.zstd,
      # drvs.gnumake,
    ],
    pDrvs = [
      drvs.openssl,
    ],
  },

  bcvkRoot | lib.DeterministicFetcher = {
    biDrvs = [
      drvs.bcvk,
      drvs.bootc,
      drvs.virtiofsd,
      drvs.podman,
      drvs.qemu,
      drvs.openssh,
    ]
  }
}
