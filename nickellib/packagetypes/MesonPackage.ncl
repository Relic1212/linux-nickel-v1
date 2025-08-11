{
  drvs,
  lib = {
    Package,
    nullOrArray,
    constants,

    MesonPackage =
      Package
      & {
        isStatic,
        enableCcache,
        isLlvm,
        stage,
        utilsProviders | not_exported,
        llvmProvider | not_exported,

        mesonArgs | nullOrArray | default = (baseMesonArgs @ extraMesonArgs),
        baseMesonArgs | Array String | default = constants.mesonArgs @ (if isStatic then constants.mesonArgsStatic else []),
        extraMesonArgs | Array String | default = [],
        configurePhase | priority -1000 = [
          "meson setup %{std.string.join constants.buildFlagSep mesonArgs} . ${SRC}"
        ],
        buildPhase | priority -1000 = [
          "meson compile"
        ],
        installPhase | priority -1000 = [
          "meson install --destdir ${DEST}"
        ],
        useMuon | Bool | default = false,
        pythonProvider | default = drvs.pythonFull,
        baseBuildinputPackages | priority -1000 =
          utilsProviders
          @ (
            if (stage == -1) then
              (
                (
                  if useMuon then
                    [
                      drvs.muon,
                      drvs.pkgconf,
                      drvs.musl,
                    ]
                  else
                    [
                      drvs.meson,
                      drvs.samurai,
                      pythonProvider,
                      drvs.pkgconf,
                      drvs.musl,
                    ]
                )
                @ (if isLlvm then [llvmProvider] else [])
                @ (if enableCcache then [drvs.ccacheBin] else [])
              )
            else
              []
          ),
      },
  }
}
