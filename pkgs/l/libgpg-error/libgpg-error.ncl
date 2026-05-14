{
  lib,
  drvs,
  libgpgError | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.51.tar.bz2",
      sha256sum = "be0f1b2db6b93eed55369cdf79f19f72750c8c7c39fc20b577e724545427e6b2"
    },
    extraEnv = {
      LDFLAGS_FOR_BUILD = ["-static", "--static"]
    }
  }
}
