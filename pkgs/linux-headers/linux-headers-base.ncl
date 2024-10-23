let
#lib=import "../../nickellib/lib.ncl"
lib = import "../../nickellib/lib.ncl"
in
# let llvmBase = import "../llvm/llvm-base.ncl"
# in
# let pkgs = {
#   muslStage0 = import "../musl/musl-stage-0.ncl",
# }
# in
let linuxHeadersBase | lib.MakePackage
  = {
    name | default = "",
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
    # configurePhase = [
    #   "cd %{buildDir}",
    #   "make defconfig"
    # ],

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
        #  "CC=%{buildEnv.CC} \\\n",
        #     "LD=%{buildEnv.CC} \\\n",
        #     "HOSTLD=%{buildEnv.CC} \\\n",
        #     "CXX=%{buildEnv.CXX} \\\n",
        #     "CPP=%{buildEnv.CXX} \\\n",
        #     "HOSTCC=%{buildEnv.CC} \\\n",
        #     "HOSTCXX=%{buildEnv.CXX} \\\n",
        #     "LDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        #     "CXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
        #     "CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
        "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
        #     # "HOSTCPPFLAGS=%{ lib.functions.varToExportvar  buildEnv.CPPFLAGS} \\\n",
        #     "HOSTCXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
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

# {
#   linuxHeadersStage0 = linuxHeadersBase & { buildInChroot = false, name = "linux-headers-stage-0", buildInputs = [
#     # pkgs.muslStage0
#      import "../musl/musl-stage-0.ncl"
#     ] },

#   linuxHeadersStage1 =
#     linuxHeadersBase
#     & {
#       name = "linux-headers-stage-1",
#       buildDir = linuxHeadersBase.buildDir,
#       # buildEnv|default=linuxHeadersBase.buildEnv,
#       #     configurePhase|priority 1 = [
#       #   "cd %{buildDir}",
#       #   "make " ++ (std.string.join " " makeArgs) ++  " defconfig",
#       #   "echo 'defconfig done'",
#       # ],
#       # makeArgs=[
#       #   "LLVM=1",
#       #   #  "CC=%{buildEnv.CC} \\\n",
#       #   #     "LD=%{buildEnv.CC} \\\n",
#       #   #     "HOSTLD=%{buildEnv.CC} \\\n",
#       #   #     "CXX=%{buildEnv.CXX} \\\n",
#       #   #     "CPP=%{buildEnv.CXX} \\\n",
#       #   #     "HOSTCC=%{buildEnv.CC} \\\n",
#       #   #     "HOSTCXX=%{buildEnv.CXX} \\\n",
#       #   #     "LDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
#       #   #     "CXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
#       #   #     "CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
#       #       "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
#       #   #     # "HOSTCPPFLAGS=%{ lib.functions.varToExportvar  buildEnv.CPPFLAGS} \\\n",
#       #   #     "HOSTCXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
#       #       "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
#       # ]@linuxHeadersBase.makeArgs,
#       buildInputs = [
#         (import "../busybox/busybox.ncl").busyboxStage0,
#         (import "../llvm/llvm-stage-0.ncl"),
#         (import "../musl/musl.ncl").muslStage1,
#         (import "../gnumake/gnumake.ncl").gnumakeStage1,
#         (import "../ccache/ccache-bin.ncl"),
#         (import "../m4/m4.ncl").m4Stage1,
#         (import "../flex/flex.ncl").flexStage1,
#         (import "../bison/bison.ncl").bisonStage1,
#       ],
#     },
# }
