let lib = import "../../nickellib/lib.ncl"
in

let ninjaBase | lib.Package
  = {
    name = "ninja",

    sourceInputs = [
      {
        src = {
          uri = "https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.1.tar.gz",
          sha256sum = "821bdff48a3f683bc4bb3b6f0b5fe7b2d647cf65d52aeb63328c91a6c6df285a"
        }
      }
    ],

    buildDir = "${SRC}",

    configurePhase = [
      "cd %{buildDir}",
      # https://github.com/ninja-build/ninja/issues/1391
      "sed -i 's@platform.supports_ninja_browse()@False@g' configure.py",
      "./configure.py --bootstrap"
    ],
    installPhase=[
      "echo 'installing directory'",
      "install -d -m0755 ${DEST}/usr/bin",
      "echo 'installing ninja'",

      "install -m0755 ./ninja  ${DEST}/usr/bin", 

    ]
  }
  in
let 
_ninjaStage1 =
    ninjaBase
    & {
      stage = 1,
      name | priority 1 = "ninja-stage-1",

    
    }
  in 
{
  muslStage0,
  busyboxStage0,pythonStage1,llvmStage0,ccacheBin,
 ninjaStage1 =
    _ninjaStage1
    & {
     

      buildInputs |priority 10= lib.biMap [muslStage0,
        busyboxStage0,pythonStage1,llvmStage0,ccacheBin

      ],
    }
}
