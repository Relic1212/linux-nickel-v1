{
  drvs,
  lib = {
    Package,
    DlPackage =
      Package
      & {
        libName | default = "dlopen",
        libs | default = [],
        buildPhase =
          ["mkdir dl-json", ]
          @ (std.array.map_with_index (fun a l => lib.functions.writeFile "dl-json/%{a}.json" (std.serialize 'Json l)) libs)
          @ [
            "dl-func %{std.array.map_with_index (fun a l=>"--file=dl-json/%{a}.json") (libs)|>std.string.join " "} > %{libName}.c",
            "${CC} ${CFLAGS} -c %{libName}.c -o %{libName}.o",
            "${AR} rcs lib%{libName}.a %{libName}.o",
          ],

        installPhase = [
          "install -dm0755 ${DEST}/usr/lib/%{libName}",
          "install -m0755 lib%{libName}.a ${DEST}/usr/lib",
          "install -m0755 %{libName}.o ${DEST}/usr/lib/%{libName}",
          "install -m0755 %{libName}.c ${DEST}/usr/lib/%{libName}",
        ],
        utilsProviders,
        muslProvider,
        isLlvm,
        llvmProviders,
        enableCcache,
        baseBuildinputPackages | not_exported | priority -1000 =
          utilsProviders
          @ (
            [drvs.pythonFull, drvs.pythonDlFunc, muslProvider]
            @ (if isLlvm then llvmProviders else [])
            @ (if enableCcache then [drvs.ccacheBin, drvs.ccacheSymlinks] else [])
          ),
      }
  }
}
