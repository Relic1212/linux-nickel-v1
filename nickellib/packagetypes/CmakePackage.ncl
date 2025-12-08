{
  drvs,
  lib = {
    constants,
    Package,
    nullOrString,

    cmakeRecordFieldToCmakeArg = (fun k v =>
      let var =
        #  ( if (
        #   std.string.substring 0 1 k != "-") then  "-D%{k}" else
        #  k )
        k
      in
      if std.is_string v then
        "%{var}=%{v}"
      else if std.is_bool v then
        (
          if v then
            "%{var}:BOOL=ON"
          else
            "%{var}:BOOL=OFF"
        )
      else if std.is_record v then
        (
          let cmakeVarType = std.record.get_or "type" (std.FailWith "type") v
          in
          let cmakeVarValue = std.record.get_or "value" (std.FailWith "value") v
          in
          "%{var}:%{cmakeVarType}=%{cmakeVarValue}"
        )
      else
        std.FailWith "cmake %{k} (%{std.typeof v}) has invalid value"
    ),
    cmakeArgsTransform = (fun r =>
      std.record.values (
        std.record.map
          cmakeRecordFieldToCmakeArg
          (
            std.record.filter
              (fun k v => v != null)
              r
          )
      )
    ),
    CmakePackage =
      Package
      & {
        # cmake,
        stage,
        isStatic,
        buildInChroot,
        isLlvm,
        enableCcache,
        utilsProviders,
        llvmProviders,

        enableParallel,
        debug,
        noDev | Bool | default = false,
        cmakeArgs | Array String | default =
          cmakeArgsPrepend
          @ (
          # std.array.sort (std.string.compare)
          (
            cmakeArgsTransform (
              {
                "-DCMAKE_BUILD_TYPE" = if debug then "Debug" else "Release",
              }
              & constants.cmakeArgsByField
              & (if isStatic then constants.cmakeArgsStaticByField else {})
              & cmakeArgsRecord
              & cmakeExtraArgsRecord
            )
          )
          )
          @ extraCmakeArgs
          @ (if noDev then ["-Wno-dev"] else []),
        cmakeArgsPrepend | Array String | default = [],

        extraCmakeArgs | Array String | default = [],
        cmakeArgsRecord | default = {},
        cmakeExtraArgsRecord | default = {},

        generator | nullOrString | default = null,

        pkgconfProvider,

        muslProvider,

        baseBuildinputPackages | priority -1000 =
          utilsProviders
          @ (
            if (stage == -1) then
              (
                [
                  drvs.cmake,
                  # drvs.pkgconf,
                  pkgconfProvider,
                  muslProvider,
                ]
                @ (if isLlvm then llvmProviders else [])
                @ (if enableCcache then [drvs.ccacheBin] else [])
                @ (if (generator == "Ninja") then [drvs.samurai] else [])
              )
            else
              []
          ),

        cmakeDir | String | default = "${SRC}",

        configurePhase | priority -10 = ["cmake -B . -S %{cmakeDir} %{std.string.join constants.buildFlagSep cmakeArgs}"],
        buildPhase | priority -10 = ["cmake --build ."],
        installPhase | priority -10 = ["DESTDIR=${DEST} cmake --install ."],
        extraEnv | priority -10 =
          (
            (if buildInChroot then Package.extraEnv else (Package & { buildInChroot = false }).extraEnv)
            & (
              if enableParallel then
                { CMAKE_BUILD_PARALLEL_LEVEL = "$(nproc)" }
              else
                {}
            )
          )
          & (if (generator == null) then {} else { CMAKE_GENERATOR = generator })
      },
  }
}
