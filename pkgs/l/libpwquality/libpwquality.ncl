{
  lib,
  drvs,
  libpwquality | lib.AutomakePackage = {
    singleSource = {
      uri = "https://github.com/libpwquality/libpwquality/archive/a66e1cd8b5e5647ceb94b554582e9508bbcc5ffa.tar.gz",
      sha256sum = "723450a0698de692791367d5518cf0ddd44120df0046c8162e56aeb14596a3c9",
    },
    extraConfigureFlags = [
      "--disable-cracklib-check",
      "--disable-python-bindings",
    ],
    biDrvs = [
      drvs.gettext,
      drvs.bash,
    ],
  }
}
