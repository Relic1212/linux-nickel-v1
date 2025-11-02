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
        configureFlags | nullOrArray | default = constants.configureFlags @ (if isStatic then constants.configureFlagsStatic else []) @ (configureFlagsFromRecord (extraFlagsByField & extraConfigureFlagsByField)) @ extraConfigureFlags,
        extraConfigureFlags | Array String | default = [],
        extraFlagsByField | default = {},
        extraConfigureFlagsByField | default = {},
        configureScript | String | default = "${SRC}/configure",
        separateBuildDir | priority -999 = true,

        configurePhase | priority -11 =
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
        configurePhase | priority -10 =
          (if (buildDir == null) then [] else ["cd %{buildDir}"])
          @ [
            "(cd ${SRC}; autoreconf -fiv)",
            configureScript ++ " " ++ (std.string.join constants.buildFlagSep configureFlags),
          ],
        pkgconfProvider,
        perlProvider | not_exported | default = drvs.perl,
        baseBuildinputPackages | priority -999 =
          AutotoolsPackage.baseBuildinputPackages
          @ (
            if (stage == -1) then
              [
                perlProvider,
                drvs.automake,
                drvs.autoconf,
                drvs.m4,
                drvs.libtool,
                pkgconfProvider,
              ]
            else
              []
          ),
      },
  }
}
