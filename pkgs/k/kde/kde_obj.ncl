{
  lib,
  drvs,
  kdeObj | lib.Package = {
    enableCcache = false,

    buildPhase = [
      m%"echo '%{import "./kde_obj.cpp" as 'Text }' > kde_obj.cpp"%,
      "clang++ --verbose -c -O2 kde_obj.cpp -o kde_obj.o",
    ],

    installPhase = [
      "install -Dm0755 kde_obj.o ${DEST}/usr/lib/kde_obj.o",
    ],

    biDrvs = [
      drvs.qtbase,
      drvs.qtdeclarative,
      drvs.llvm,
      drvs.musl,
    ]
  }
}
