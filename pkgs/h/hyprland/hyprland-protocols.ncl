{
  lib,
  drvs,
  hyprlandProtocols | lib.MesonPackage = {
    sourceInputs = [
      {
        src = {

          uri = "https://github.com/hyprwm/hyprland-protocols/archive/refs/tags/v0.7.0.tar.gz",
          sha256sum = "ee419006d7cd20927b9b7c8b5fc430571c151b0385d600508de1a7957294498c",
        }
      },
    ]
  }
}
