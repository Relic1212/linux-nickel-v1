{
  drvs,
  lib = {
    Package,
    nullOrArray,

    MakePackage =
      Package
      & {
        enableParallel,
        makeArgs | not_exported | nullOrArray | default = ["PREFIX=/usr"] @ (if enableParallel then ["-j$(nproc)"] else []) @ extraMakeArgs,
        extraMakeArgs | not_exported | Array String | default = [],
        makeTargets | not_exported | nullOrArray | default = null,
        makeInstallArgs | not_exported | nullOrArray | default = ["DESTDIR=${DEST}"] @ extraMakeInstallArgs,
        extraMakeInstallArgs | not_exported | Array String | default = [],
        makeInstallTargets | not_exported | nullOrArray | default = ["install"],
        utilsProviders,
        stage,
        isLlvm,
        enableCcache,
        separateBuildDir | priority -1000 = false,
        llvmProviders | not_exported,
        muslProvider | not_exported,
        baseBuildinputPackages | not_exported | priority -1000 =
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

        buildPhase | not_exported | priority -10 = [
          "make " ++ (std.string.join " " makeArgs) ++ (if makeTargets == null then "" else " " ++ std.string.join " " makeTargets)
        ],
        installPhase | not_exported | priority -10 = [
          "make " ++ (std.string.join " " makeInstallArgs) ++ " " ++ (std.string.join " " makeInstallTargets)
        ]
      },
  }
}
