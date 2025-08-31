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
        debug,
        stage,
        utilsProviders | not_exported,
        llvmProvider | not_exported,
        muslProvider | not_exported,

        mesonArgs | nullOrArray | default = (baseMesonArgs @ extraMesonArgs),
        baseMesonArgs | Array String | default = (if (!debug) then constants.mesonArgs else constants.mesonArgsDebug) @ (if isStatic then constants.mesonArgsStatic else []),
        extraMesonArgs | Array String | default = [],
        configurePhase | priority -1000 =
          if (!useMuon) then
            [
              "meson setup %{std.string.join constants.buildFlagSep mesonArgs} . ${SRC}"
            ]
          else
            [
              "(cd ${SRC} && meson setup %{std.string.join constants.buildFlagSep mesonArgs} ../build .)"
            ],
        buildPhase | priority -1000 =
          if (!useMuon) then
            [
              "meson compile"
            ]
          else
            [
              "(cd ${SRC} && meson compile -C ../build)"
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
                      muslProvider,
                    ]
                  else
                    [
                      drvs.meson,
                      drvs.samurai,
                      pythonProvider,
                      drvs.pkgconf,
                      muslProvider,
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
