let lib = import "../../nickellib/lib.ncl"
in

let ninjaBase | lib.Package
  = {
    name = "ninja",

    sourceInputs = [
      {
        src = {
          uri = "https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.1.tar.gz",
          sha256sum = "1"
        }
      }
    ],

    buildDir = "${SRC}",

    configurePhase = [
      "cd %{buildDir}",
      "./configure.py --bootstrap"
    ],
  }
  in
{
  ninjaStage1 =
    ninjaBase
    & {
      stage = 1,
      name | priority 1 = "ninja-stage-1",

      buildInputs = [
        # (import "../busybox/busybox.ncl").busyboxStage0,
        # (import "../llvm/llvm-stage-0.ncl"),
        # (import "../musl/musl-stage-0.ncl"),
        #  (import "../python/python.ncl").pythonStage1,
      ],
    }
}
