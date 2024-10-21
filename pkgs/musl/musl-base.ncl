let lib=import "../../nickellib/lib.ncl"
in 

let musl|lib.AutotoolsPackage={
    isLlvm|default=lib.AutotoolsPackage.isLlvm,
    name="musl",
    isStatic=false,
    sourceInputs=[{
        src={uri="https://musl.libc.org/releases/musl-1.2.5.tar.gz",sha256sum="a9a118bbe84d8764da0ea0d28b3ab3fae8477fc7e4085d90102b8596fc7c75e4"}
    }],
    extraEnv|priority -10=lib.AutotoolsPackage.extraEnv & (if isLlvm then {LIBCC_LDFLAGS=["--rtlib=compiler-rt"]}else {} ),
}
in 
musl