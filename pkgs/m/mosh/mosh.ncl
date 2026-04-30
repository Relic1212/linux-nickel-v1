{
  lib,
  drvs,
  mosh | lib.AutomakePackage = {
    singleSource = {
      #   uri = "https://github.com/mobile-shell/mosh/archive/refs/tags/mosh-1.4.0.tar.gz",
      #   sha256sum = "ae581fbddf038730af9eee4d319a483288395a0722d0c94c7efb7fdbdbb0dbac",

      uri = "https://github.com/mobile-shell/mosh/archive/f7b350f0a8a2cb85718631c829872136533509da.tar.gz",
      sha256sum = "755a785edb3af8dc21253a40b5885c79057264d42c183285ddd6c43598fb6f9e",
    },
    configureScript,
    configureFlags,
    separateBuildDir = false,
    configurePhase = [
      "./autogen.sh",
      configureScript ++ " " ++ (std.string.join lib.constants.buildFlagSep configureFlags),
    ],
    biDrvs = [
      drvs.protobuf,
      drvs.zlibNg,
      drvs.readline,
      drvs.ncurses,
      drvs.openssl,
      drvs.abseilCpp,
    ],
  }
}
