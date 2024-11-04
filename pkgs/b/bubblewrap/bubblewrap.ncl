{
  lib,
  drvs,
  bubblewrap | lib.MesonPackage
    = {
      singleSource = {
        uri = "https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz",
        sha256sum = "988fd6b232dafa04b8b8198723efeaccdb3c6aa9c1c7936219d5791a8b7a8646",
      },
      biDrvs = [
        drvs.libcap,
        drvs.zsh,
        drvs.linuxHeaders,
      ],
      extraMesonArgs = [
        "-Dbash_completion=disabled",
        "-Dzsh_completion=enabled",
        "-Dtests=false"
      ]
    }
}
