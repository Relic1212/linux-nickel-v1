let lib = import "../../nickellib/lib.ncl"
in
{
  busybox,
  pythonFull,
  musl,
  llvm,
  pythonSetuptools | lib.SetuptoolPackage
    = {
      name = "python-setuptools",
      singleSource = {
        uri = "https://github.com/pypa/setuptools/archive/refs/tags/v75.1.0.tar.gz",
        sha256sum = "514dc60688d3118c9883a3dd54a38b28128ea912c01ea325d6e204a93da3b524",
      },
      pythonExecutable = "python3",
      buildInputs = lib.biMap [busybox, pythonFull]
    }
}
