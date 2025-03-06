{
  lib,

  libffi | lib.AutotoolsPackage = {
    name = "libffi",
    singleSource = {
      uri = "https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz",
      sha256sum = "d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676",
    },
    configureFlags =
      lib.AutotoolsPackage.configureFlags
      @ [
        "--enable-portable-binary",
        "--disable-exec-static-tramp",
      ],
  }
}
