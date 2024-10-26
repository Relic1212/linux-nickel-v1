{
  lib,

  pkgs,

  openssl | lib.AutotoolsPackage
    =
      let _openssl | lib.AutotoolsPackage
        = {
          name = "openssl",
          configureScript = "./Configure",
          configureFlags = ["--prefix=/usr", "--libdir=lib", "--openssldir=/etc/ssl"],
          singleSource = {
            uri = "https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz",
            sha256sum = "2e8a40b01979afe8be0bbfb3de5dc1c6709fedb46d6c89c10da114ab5fc3d281",
          }
        }
        in
      (
        _openssl
        & {
          configurePhase =
            [
              "cd ${SRC}",
              "sed -i \"s@disable('static', 'pic', 'threads');@disable('static', 'pic');@g\" ${SRC}/Configure",
            ]
            @ _openssl.configurePhase,
          biPkgs = [pkgs.perl, pkgs.linuxHeaders]
        }
      ),

  opensslPic =
    openssl
    & {
      name | priority 1 = "openssl-pic",
      preConfigurePhase = [
        "export CFLAGS=\"${CFLAGS} -fPIC\"",
        "export CXXFLAGS=\"${CXXFLAGS} -fPIC\"",
        "export LDFLAGS=\"${LDFLAGS} -fPIC\"",
      ]
    }
}
