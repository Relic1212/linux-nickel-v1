let lib = import "../../nickellib/lib.ncl"
in
let constants = import "../../nickellib/constants.ncl"
in
let compilerRt | lib.CmakePackage
  ={
    cmakeArgs|default=lib.CmakePackage.cmakeArgs,
    name|priority -10="copmiler-rt",
    sourceInputs=(import "../llvm/llvm-base.ncl").sourceInputs,
    configurePhase | priority -9 = ["cmake ${SRC}/llvm %{std.string.join (constants.buildFlagSep) cmakeArgs}"],

}
in 
let 
pkgs={
    compilerRtStage0=(
        compilerRt&{
            name="compiler-rt-stage-0",
            buildEnv|priority 1 =(compilerRt.buildEnv& {
                 CPPFLAGS = [
             # "--sysroot=/tmp/workdir/sysroot/",
              # "-L/tmp/workdir/sysroot/usr/lib",
             "-I/tmp/workdir/sysroot/usr/include",
             #  "-idirafter=/tmp/workdir/sysroot/"
            ],
            CFLAGS|priority 1 =(compilerRt.buildEnv.CFLAGS @ CPPFLAGS),
            CXXFLAGS|priority 1 =(compilerRt.buildEnv.CXXFLAGS @ CPPFLAGS),
            LDFLAGS|priority 1=(compilerRt.buildEnv.CXXFLAGS @ ["-L/tmp/workdir/sysroot/usr/lib" ]),
            }),
        
            
            buildInputs|priority 1=[
                import "../musl/musl-stage-0.ncl",
                import "../linux-headers/linux-headers-stage-0.ncl",
            ],
            buildInChroot|priority 1=false,
            }
            ),
}
in pkgs 