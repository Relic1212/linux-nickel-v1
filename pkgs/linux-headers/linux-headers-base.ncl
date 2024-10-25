let lib = import "../../nickellib/lib.ncl"
in

let linuxHeadersBase | lib.MakePackage
  = {
    baseName = "linux-headers",
    makeTargets | priority -10 = ["headers"],
    sourceInputs = [
      {
        src = {
          uri = "https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.gz",
          sha256sum = "37041701dab67f8e1bd699d728fec07d6098abd147b366f0c7ad1a3fb1b58619",
        },
      },
    ],
    buildDir = "/tmp/workdir/src",

    buildEnv | default = lib.MakePackage.buildEnv,
    configurePhase | priority 1
      = [
        "cd %{buildDir}",
        "make " ++ (std.string.join " " makeArgs) ++ " defconfig",
        "echo 'defconfig done'",
      ],
    makeArgs =
      [
        "LLVM=1",
        "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      ]
      @ lib.MakePackage.makeArgs,

    installPhase = [
      "install -d -m0755 ${DEST}/usr",
      "cp -r ./usr/include ${DEST}/usr",
    ]
  }
  in

linuxHeadersBase
