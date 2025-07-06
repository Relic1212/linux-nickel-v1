{
  lib,
  gnumake,
  protobuf,

  netavark | lib.CargoPackage = {
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/containers/netavark/archive/refs/tags/v1.13.0.tar.gz",
          sha256sum = "34862383aee916677333b586f57d8b1d29f94676029da23c9a1ad1fcb509d1c1"
        }
      },
      {
        dest = "vendor",
        src = {
          uri = "https://github.com/containers/netavark/releases/download/v1.13.0/netavark-v1.13.0-vendor.tar.gz",
          sha256sum = "9826111981f02f4b9dbf1fbffad4d55fd0c9b33a1fd895391c601c50c5a79b2b"
        }
      }
    ],
    # cargoFlags=[
    #     "--offline", "--target x86_64-unknown-linux-musl",
    # ],
    cargoFlags,
    buildPhase = [
      m%"
        make \
            release="%{std.string.join " " cargoFlags}" \
            profile="x86_64-unknown-linux-musl/release" \
            PREFIX=/usr
        "%,
    ],
    installPhase = [
      "echo \"all: \n\techo 1\n\" > docs/Makefile",
      "echo \"\ninstall: \n\techo 1\n\" >> docs/Makefile",
      m%"
        make \
            release="%{std.string.join " " cargoFlags}" \
            profile="x86_64-unknown-linux-musl/release" \
            PREFIX=/usr \
            DESTDIR=${DEST} \
            install
        "%,
    ],
    biDrvs =
      lib.biMap [
        gnumake,
        protobuf,
      ]
  }
}
