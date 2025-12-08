{
  lib,
  drvs,
  wlrProtocols | lib.MakePackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/wlroots/wlr-protocols/-/archive/a741f0ac5d655338a5100fc34bc8cec87d237346/wlr-protocols-a741f0ac5d655338a5100fc34bc8cec87d237346.tar.bz2",
      sha256sum = "e6ff487bee83f4196290f7da124a0f369a922a908eb9ea1ce8938b51f912f138"
    },
    biDrvs = [
      drvs.wayland,
      drvs.waylandProtocols,
    ]
  }
}
