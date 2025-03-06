{
  lib,
  drvs,
  gnupg | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.23.tar.bz2",
      sha256sum = "c9462f17e651b6507848c08c430c791287cd75491f8b5a8b50c6ed46b12678ba"
    },
    configureFlags = []
  }
}
