{
  lib,
  drvs,
  ashell1 | lib.CargoPackage =
    let gitSrcs = import "src.ncl" in
    {
      singleSource = {
        uri = "https://github.com/MalpenZibo/ashell/archive/refs/tags/0.7.0.tar.gz",
        sha256sum = "ea73d22b729ec2c4bb6af1cfce4cb597e8c9c6d657776d3d5575d4e3868925b6",
      },
      crates = lib.functions.filterCrates (import "ashell-crates.json"),
      nonCrateSourceInputs =
        [
          { src = singleSource },
        ]
        @ gitSrcs,

      configurePhase =
        (
          std.array.map
            (fun s => "cargo-package-vendor %{s.dest} vendor/"
            )
          ###
          # gitSrcs
          ########
            []
          ########
        )
        @ [
          m%"echo '[source.crates-io]
replace-with = "vendored-sources"

[source."git+https://github.com/MalpenZibo/iced?rev=237116726a405b326bf6f61f2b9105b38a938490"]
git = "https://github.com/MalpenZibo/iced"
rev = "237116726a405b326bf6f61f2b9105b38a938490"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-protocols?rev=d0e95be"]
git = "https://github.com/pop-os/cosmic-protocols"
rev = "d0e95be"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/cosmic-text.git"]
git = "https://github.com/pop-os/cosmic-text.git"
replace-with = "vendored-sources"

[source."git+https://github.com/pop-os/glyphon.git?tag=iced-0.14-dev"]
git = "https://github.com/pop-os/glyphon.git"
tag = "iced-0.14-dev"
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
' > .cargo/config.toml"%
        ]
        # @ (
        #     std.array.map (
        #         fun s args => "echo 'packaging in %{s}'\nCARGO_ARG=%{args} cargo-package-vendor %{s} vendor/"
        #     )[
        #         ("vendor-7" "--no-verify -p dnd"),
        #         ("vendor-7/mime" ""),

        #         # "vendor-7/mime",
        #         # "vendor-7/dnd",
        #         ("vendor-1" ""),
        #         ("vendor-2" ""),
        #     ]
        # ) 
        @ [
          m%"export CARGO_ARGS="--no-verify --offline --exclude-lockfile""%,
          m%"cargo-package-vendor vendor-3 vendor/"%,
          m%"cargo-package-vendor vendor-4 vendor/"%,
          m%"export CARGO_ARGS="--no-verify --offline --exclude-lockfile --workspace""%,
          m%"cargo-package-vendor vendor-7 vendor/"%,
        ],
      biDrvs = [
        drvs.cargoPackageVendor,
      ]
    },
  cargoPackageVendor | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/bin",
      "echo '%{import "cargo-package-vendor.sh" as 'Text}' > ${DEST}/usr/bin/cargo-package-vendor",
      "chmod +x ${DEST}/usr/bin/cargo-package-vendor",
    ]
  }
}
