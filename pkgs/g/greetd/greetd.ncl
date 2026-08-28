{
  lib,
  drvs,
  greetd | lib.CargoPackage = {
    singleSource = {
      uri = "https://git.sr.ht/~kennylevinsen/greetd/archive/0.10.3.tar.gz",
      sha256sum = "ee5cb70e0add4ca9c9fe57e47581ab0002d44c07743fb5492469f3b570db640b"
    },

    crates = lib.functions.filterCrates (import "greetd-crates.json"),
    options = {
      selinux | default = false,
    },
    extraEnv.EXTRA_RUSTFLAGS =
      ["-C link-arg=-lcap"]
      @ (
        if options.selinux then
          [
            "-C link-arg=/usr/lib/security/pam_elogind.a",
            "-C link-arg=/usr/lib/security/pam_gnome_keyring.a",
            m%"$(for l in $(pkg-config --libs --static pam libselinux);do printf " -C link-arg=$l ";done)"%,
          ]
        else
          []
      ),
    preInstallPhase = [
      "cd man",
      "make PREFIX=/usr",
      "cd .."
    ],
    postInstallPhase = [
      "install -dm0755 ${DEST}/etc/greetd",
      "install -m0755 config.toml ${DEST}/etc/greetd",
      "cd man",
      "make PREFIX=/usr DESTDIR=${DEST} install",
      "cd .."
    ],
    biDrvs =
      [
        drvs.libcap,
        drvs.scdoc,
        drvs.gnumake,
      ]
      @ (
        if options.selinux then
          [
            drvs.selinux,
            drvs.muslFts,
            drvs.auditUserspace,
            drvs.libpamSelinux,
            drvs.pcre2,
            drvs.bzip2,
            drvs.elogindSelinux,
            drvs.gnomeKeyring,
          ]
        else
          [
            drvs.libpamFinal,
          ]
      ),
  },
  greetdSelinux | lib.CargoPackage =
    greetd
    & {
      options.selinux = true,
    }
}
