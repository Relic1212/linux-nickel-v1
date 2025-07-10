{
  lib,

  llvmEtc | lib.Package = {
    #name = "llvm-etc",
    buildInChroot = false,
    installPhase = [
      "install -d -m0755 ${DEST}/etc/clang",
      m%"
    echo "
    --rtlib=compiler-rt
    --unwindlib=libunwind
    --stdlib=libc++
    -fuse-ld=lld
    " > ${DEST}/etc/clang/runtimes.cfg
    "%
    ]
  }
}
