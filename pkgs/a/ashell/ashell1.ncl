{
  lib,
  drvs,

  cargoPackageVendor | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "echo '%{import "cargo-package-vendor.sh" as 'Text}' > ${DEST}/usr/bin/cargo-package-vendor",
      "chmod +x ${DEST}/usr/bin/cargo-package-vendor",
    ]
  }
}
