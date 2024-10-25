{
  lib,
  bash | lib.AutotoolsPackage
    = {
      configureFlags = lib.AutotoolsPackage.configureFlags @ ["--without-bash-malloc", "--disable-nls", "--with-curses=no", "--enable-readline=no"],
      name = "bash",
      sourceInputs = [
        {
          src = {
            uri = "https://ftp.gnu.org/gnu/bash/bash-5.2.32.tar.gz",
            sha256sum = "d3ef80d2b67d8cbbe4d3265c63a72c46f9b278ead6e0e06d61801b58f23f50b5"
          }
        }
      ]
    }
}
