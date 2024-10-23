let lib = import "../../nickellib/lib.ncl"
in
let m4Base|lib.AutotoolsPackage={
    name|priority -10="m4",
    buildEnv=(lib.AutotoolsPackage.buildEnv&{LD="lld"}),
    sourceInputs=[
        {
            src={
            uri="https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz",
            sha256sum="63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
            }
        }
    ],
    buildDir="${SRC}",

}
in 
m4Base