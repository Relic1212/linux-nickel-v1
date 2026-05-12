{
  lib,
  drvs,
  lib = {
    MakePackage,
    nullOrArray,
    constants,

    #  configureFieldToFlag = (fun k v =>
    #         let var = "--%{k}" in
    #         if std.is_string v then
    #           "%{var}=%{v}"
    #         else if v==null then
    #         var
    #         else
    #           std.FailWith " %{k} (%{std.typeof v}) has invalid type, must be string or null"
    #       ),
    configureFlagsFromRecord = (fun r =>
      let flagOpts = std.record.fields r in
      # make a flag empty by leaving it unspecified of setting it to false
      # {"--disable-shared",} same as {"--disable-shared"=false,}
      let mapped = std.array.map (fun f => { flag = f, value = std.record.get_or "%{f}" false r }) flagOpts in
      # remove a flag by setting "--disable-shared"=null
      let filtered = std.array.filter (fun x => x.value != null) mapped in
      let finalFlags = std.array.map (fun x => (if x.value == false then x.flag else "%{x.flag}=%{x.value}")) filtered in
      finalFlags
    ),
    AutotoolsPackage =
      MakePackage
      & {
        isStatic,
        buildDir,
        configureFlags | not_exported | nullOrArray | default = constants.configureFlags @ (if isStatic then constants.configureFlagsStatic else []) @ (configureFlagsFromRecord (extraFlagsByField & extraConfigureFlagsByField)) @ extraConfigureFlags,
        extraConfigureFlags | not_exported | Array String | default = [],
        extraFlagsByField | not_exported | default = {},
        extraConfigureFlagsByField | not_exported | default = {},
        configureScript | not_exported | String | default = "${SRC}/configure",
        separateBuildDir | not_exported | priority -999 = true,

        configurePhase | not_exported | priority -11 =
          (if (buildDir == null) then [] else ["cd %{buildDir}"])
          @ [
            configureScript ++ " " ++ (std.string.join constants.buildFlagSep configureFlags)
          ]
      },
    AutomakePackage =
      AutotoolsPackage
      & {
        stage,
        buildDir,
        configureScript,
        configureFlags,
        configurePhase | not_exported | priority -10 =
          (if (buildDir == null) then [] else ["cd %{buildDir}"])
          @ [
            "(cd ${SRC}; autoreconf -fiv)",
            configureScript ++ " " ++ (std.string.join constants.buildFlagSep configureFlags),
          ],
        pkgconfProvider | not_exported,
        muslProvider | not_exported,
        perlProvider | not_exported | default = drvs.perl,
        utilsProviders | not_exported,
        isLlvm,
        llvmProviders | not_exported,
        enableCcache,
        baseBuildinputPackages | not_exported | priority -999 =
          # AutotoolsPackage.baseBuildinputPackages
          AutotoolsPackage.utilsProviders
          @ (
            if (stage == -1) then
              (
                [drvs.gnumake, muslProvider]
                @ (if isLlvm then AutotoolsPackage.llvmProviders else [])
                @ (if enableCcache then [drvs.ccacheBin, drvs.ccacheSymlinks] else [])
                @ [
                  perlProvider,
                  drvs.automake,
                  drvs.autoconf,
                  drvs.m4,
                  drvs.libtool,
                  pkgconfProvider,
                ]
              )
            else
              []
          ),
      },
  }
}
