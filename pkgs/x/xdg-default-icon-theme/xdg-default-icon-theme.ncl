{
  lib,
  drvs,
  xdgDefaultIconTheme | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/xdg/default-icon-theme/-/archive/v0.18/default-icon-theme-v0.18.tar.bz2",
      sha256sum = "a7004bd23e14497ed87aa3a421f55364acbf4c29a434568070552ca5544c8350",
    }
  }
}
