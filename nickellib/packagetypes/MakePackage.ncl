{
  drvs,
  lib = {
    Package,
    nullOrArray,

    MakePackage =
      Package
      & {
        enableParallel,
        makeArgs | nullOrArray | default = ["PREFIX=/usr"] @ (if enableParallel then ["-j$(nproc)"] else []) @ extraMakeArgs,
        extraMakeArgs | Array String | default = [],
        makeTargets | nullOrArray | default = null,
        makeInstallArgs | nullOrArray | default = ["DESTDIR=${DEST}"] @ extraMakeInstallArgs,
        extraMakeInstallArgs | Array String | default = [],
        makeInstallTargets | nullOrArray | default = ["install"],
        utilsProviders,
        stage,
        isLlvm,
        enableCcache,
        separateBuildDir | priority -1000 = false,
        llvmProviders | not_exported,
        muslProvider,
        baseBuildinputPackages | priority -1000 =
          utilsProviders
          @ (
            if (stage == -1) then
              (
                [drvs.gnumake, muslProvider]
                @ (if isLlvm then llvmProviders else [])
                @ (if enableCcache then [drvs.ccacheBin, drvs.ccacheSymlinks] else [])
              )
            else
              []
          ),

        buildPhase | priority -10 = [
          "make " ++ (std.string.join " " makeArgs) ++ (if makeTargets == null then "" else " " ++ std.string.join " " makeTargets)
        ],
        installPhase | priority -10 = [
          "make " ++ (std.string.join " " makeInstallArgs) ++ " " ++ (std.string.join " " makeInstallTargets)
        ]
      },
  }
}
