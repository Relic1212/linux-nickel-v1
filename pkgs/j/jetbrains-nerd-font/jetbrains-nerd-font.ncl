{
  lib,
  drvs,
  jetbrainsNerdFont | lib.Package = {
    singleSource = {
      uri = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip",
      sha256sum = "76f05ff3ace48a464a6ca57977998784ff7bdbb65a6d915d7e401cd3927c493c",
    }
  }
}
