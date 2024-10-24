let lib = import "../../nickellib/lib.ncl"
in
let flexBase | lib.AutotoolsPackage
  = {
    buildEnv = (lib.AutotoolsPackage.buildEnv & { LD | default = "lld" }),

    baseName | priority -10 = "flex",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz",
          sha256sum = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
        }
      }
    ],
    buildDir = "${SRC}"
  }
  in
flexBase
