let lib = import "../../nickellib/lib.ncl" in

{

  busybox,
  llvm,
  musl,
  ccacheBin,
  gnumake,
  m4,

  libtool | lib.AutotoolsPackage
    = {
      name = "libtool",

      singleSource = {
        uri = "https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz",
        sha256sum = "04e96c2404ea70c590c546eba4202a4e12722c640016c12b9b2f1ce3d481e9a8",
      },
      buildInputs =
        lib.biMap [
          busybox,
          llvm,
          musl,
          ccacheBin,
          gnumake,
          m4
        ],
    }
}
