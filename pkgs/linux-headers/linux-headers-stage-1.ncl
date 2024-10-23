
let linuxHeadersBase = (import "./linux-headers-base.ncl")
in 

let 


  linuxHeadersStage1 =
    linuxHeadersBase
    & {
      name = "linux-headers-stage-1",
      buildDir = linuxHeadersBase.buildDir,
      # buildEnv|default=linuxHeadersBase.buildEnv,
      #     configurePhase|priority 1 = [
      #   "cd %{buildDir}",
      #   "make " ++ (std.string.join " " makeArgs) ++  " defconfig",
      #   "echo 'defconfig done'",
      # ],
      # makeArgs=[
      #   "LLVM=1",
      #   #  "CC=%{buildEnv.CC} \\\n",
      #   #     "LD=%{buildEnv.CC} \\\n",
      #   #     "HOSTLD=%{buildEnv.CC} \\\n",
      #   #     "CXX=%{buildEnv.CXX} \\\n",
      #   #     "CPP=%{buildEnv.CXX} \\\n",
      #   #     "HOSTCC=%{buildEnv.CC} \\\n",
      #   #     "HOSTCXX=%{buildEnv.CXX} \\\n",
      #   #     "LDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
      #   #     "CXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
      #   #     "CFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      #       "HOSTLDFLAGS=%{ lib.functions.varToExportvar buildEnv.LDFLAGS} \\\n",
      #   #     # "HOSTCPPFLAGS=%{ lib.functions.varToExportvar  buildEnv.CPPFLAGS} \\\n",
      #   #     "HOSTCXXFLAGS=%{ lib.functions.varToExportvar  buildEnv.CXXFLAGS} \\\n",
      #       "HOSTCFLAGS=%{ lib.functions.varToExportvar  buildEnv.CFLAGS} \\\n",
      # ]@linuxHeadersBase.makeArgs,
      buildInputs = [
        (import "../busybox/busybox-stage-0.ncl"),
        (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-1.ncl"),
        (import "../gnumake/gnumake.ncl").gnumakeStage1,
        (import "../ccache/ccache-bin.ncl"),
        (import "../m4/m4.ncl").m4Stage1,
        (import "../flex/flex.ncl").flexStage1,
        (import "../bison/bison.ncl").bisonStage1,
      ],
    }


in
linuxHeadersStage1