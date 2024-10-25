let lib = import "../../nickellib/lib.ncl"
in
let _openssl | lib.AutotoolsPackage
  = {
    name = "openssl",
    configureScript = "./Configure",
    # buildEnv=lib.AutotoolsPackage.buildEnv&{
    #     CPPFLAGS=["-I/sysroot/usr/include/c++/v1/"],
    # },
    configureFlags = ["--prefix=/usr", "--libdir=lib", "--openssldir=/etc/ssl"],
    singleSource = {
      uri = "https://github.com/openssl/openssl/releases/download/openssl-3.3.2/openssl-3.3.2.tar.gz",
      sha256sum = "2e8a40b01979afe8be0bbfb3de5dc1c6709fedb46d6c89c10da114ab5fc3d281",
    }
  }
  in
{
  llvm,
  busybox,
  gnumake,
  ccacheBin,
  perl,
  musl,
  linuxHeaders,
  openssl =
    _openssl
    & {
      configurePhase =
        [
          "cd ${SRC}",
          "sed -i \"s@disable('static', 'pic', 'threads');@disable('static', 'pic');@g\" ${SRC}/Configure",
          # "ln -s ${SRC}/Configure ${SRC}/configure",
        ]
        @ _openssl.configurePhase,
      buildInputs = lib.biMap [llvm, busybox, gnumake, ccacheBin, perl, musl, linuxHeaders, ],
    }
}
