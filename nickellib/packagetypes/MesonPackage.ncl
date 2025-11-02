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

        llvmProviders | not_exported,
        muslProvider | not_exported,

        mesonArgs | nullOrArray | default = (baseMesonArgs @ extraMesonArgs),
        baseMesonArgs | Array String | default = (if (!debug) then constants.mesonArgs else constants.mesonArgsDebug) @ (if isStatic then constants.mesonArgsStatic else []),
        extraMesonArgs | Array String | default = [],
        configurePhase | priority -1000 =
          if (
            !useMuon
            # true
            ) then
            [
              "meson setup %{std.string.join constants.buildFlagSep mesonArgs} . ${SRC}"
            ]
          else
            [
              "(cd ${SRC} && meson setup %{std.string.join constants.buildFlagSep mesonArgs} ../build)"
            ],
        buildPhase | priority -1000 =
          if (
            !useMuon
            # true
            ) then
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
        usePkgconf | Bool | default = true,
        pkgconfProvider,

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
                      drvs.samurai,
                      muslProvider,
                    ]
                  else
                    [
                      drvs.meson,
                      drvs.samurai,
                      pythonProvider,
                      muslProvider,
                    ]
                )
                @ (if usePkgconf then [ 
                  # drvs.pkgconf
                  pkgconfProvider
                  ] else [])
                @ (if isLlvm then llvmProviders else [])
                @ (if enableCcache then [drvs.ccacheBin] else [])
              )
            else
              []
          ),
      },
  }
}
