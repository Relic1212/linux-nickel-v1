let
#lib=import "../../nickellib/lib.ncl"
lib = import "../../nickellib/lib.ncl"
in
let llvmBase = import "./llvm-base.ncl"
in
let pkgs = {
  muslStage0 = import "../musl/musl-stage-0.ncl",
}
in
in
let linuxHeadersBase|lib.MakePackage={
    name|default="",
    makeTargets|priotity -10=[""],
    sourceInputs=[{
        src={
            uri="https://mirrors.edge.kernel.org/pub/linux/kernel/v6.x/linux-6.10.tar.gz",
            sha256sum="37041701dab67f8e1bd699d728fec07d6098abd147b366f0c7ad1a3fb1b58619",
        },
    },],
}
in {
    linuxHeadersStage0=linuxHeadersBase&{buildInChroot=false}
}