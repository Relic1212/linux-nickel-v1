{
  lib,
  pkgs,

  _ninja | lib.Package
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
      installPhase = [
        "echo 'installing directory'",
        "install -d -m0755 ${DEST}/usr/bin",
        "echo 'installing ninja'",
        "install -m0755 ./ninja  ${DEST}/usr/bin",
      ]
    },

  ninjaStage1 =
    _ninja
    & {
      stage = 1,
      name | priority 1 = "ninja-stage-1",
      buildInputs | priority 10
        =
          lib.biMap [
            pkgs.muslStage0,
            pkgs.busyboxStage0,
            pkgs.pythonStage1,
            pkgs.llvmStage0,
            pkgs.ccacheBin
          ],
    }
}
