{
  lib,
  drvs,
  cosmicEpochSources | lib.DeterministicFetcher = {
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
      #   "git submodule init",
      "for d in $(ls); do",
      " if [ -e ${d}/Cargo.toml ]; then",
      "   echo \"fetching for ${d}\"",
      "  (cd ${d} && mkdir -p .cargo)",
      "  (cd ${d} && cargo vendor --versioned-dirs --no-delete --locked ../vendor >> .cargo/config.toml)",
      " fi",
      "done",
      # https://superuser.com/questions/705877/compressing-compressed-tar-gz-files-deterministically
      m%"find .. -print0 | xargs -0r touch --no-dereference --date="@1302044400""%,
      "rm -rf .git",
      "tar --mtime='2015-10-21 00:00Z' -cf - . > ../../build/%{outputFile}",
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
      drvs.gnutar & { priority = 1 },
    ],
  }
}
