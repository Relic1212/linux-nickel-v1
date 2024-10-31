let constants = import "./constants.ncl"
in
let _constants = constants
# in
# let shellFunctions = import "./shellFunctions.ncl"
in
let drvUtils = import "drv.ncl"
in

{
  pkgs, #| default = import "pkgsRecord.ncl",
  # hashByName,

  lib =
    (import "buildEnv.ncl")
    & {
      BuildEnv,
      nullEnv,
      staticEnv,
      llvmEnv,
      staticLlvmEnv,
      shellFunctions = import "./shellFunctions.ncl",
      # biMap = (fun arr => std.array.map (fun x => drvUtils.pkgToHash x) arr),
      biMap = (fun arr => std.array.map (fun x => { name = x.name, drvHash = x.drvHash }) arr),

      # biMap2 = (fun arr => std.array.map (fun x => (hashByName."%{x}") ) arr),

      constants = _constants,
      functions | not_exported
        = {
          computeSha256 = (fun s => (std.hash 'Sha256) s),
          recordToHash = fun r => computeSha256 (std.serialize 'Json r),
          isNullOrString = (fun s => std.is_string s || s == null),
          isNullArray = (fun a => std.is_array a || a == null),
          isStringOrArray = (fun a => std.is_array a || std.is_string a),
          isNullOrStringOrArray = (fun a => std.is_array a || std.is_string a || a == null),

          varToExportvar = (fun var =>
            if ((std.typeof var) == '"String") then
              var
            else
              "\"" ++ (std.string.join " " var) ++ "\""
          ),
          createExport = (fun key env => (if (std.record.has_field key env) then "export %{key}=%{varToExportvar env."%{key}"}" else "")),
          joinArraysInSecondRecordWithArraysInFirstRecord = (fun a b => std.record.map (fun x y => if ((std.is_array y) && (std.record.has_field x b)) then y @ b."%{x}" else y) a),
          replaceArraysWithEmptyArrays = (fun a => (std.record.map_values (fun x => (if (std.is_array x) then [] else x)) a)),
          joinMerge = (fun a b => ((joinArraysInSecondRecordWithArraysInFirstRecord a b) & (std.record.filter (fun f v => ((std.is_array v) == false)) b))),
          # cmakeVarToString=(fun v =>( if (std.is_string v) then "=%{v}" else if (std.is_record v) then ":%{v.type}=%{v.value}" else if (std.typeof v=="'Bool") then (if v then ":BOOL=ON" else ":BOOL=OFF") )),
          cmakeRecordToArgs = (fun r => (std.record.values (std.record.map (fun field value => "-D%{field}=%{value}") r))),
          replaceArrayElem = (fun old new arr => (std.array.map (fun elem => (if (elem == old) then new else elem)) arr)),

          arrayContainsDups = (fun arr =>
            (
              (std.array.fold_left (fun arrp elem => ({ a = (arrp.a @ [elem]), b = ((std.array.elem elem arrp.a) || arrp.b) })) { a = [], b = false } arr).b
            )
          ),
          hasNoDups = (fun arr => ((arrayContainsDups arr) == false)),
          allHaveLen = (fun len arr => (false == (std.array.elem false (std.array.map (fun s => ((std.string.length s) == len)) arr)))),
          isValidShasumArray = (fun arr => ((hasNoDups arr) && (allHaveLen 64 arr))),
        },
      nullOrString = std.contract.from_predicate (functions.isNullOrString),

      nullOrArray = std.contract.from_predicate (functions.isNullArray),
      StringOrArray = std.contract.from_predicate (functions.isStringOrArray),
      NullOrStringOrArray = std.contract.from_predicate (functions.isNullOrStringOrArray),

      ShasumArray1 = std.contract.from_predicate (functions.isValidShasumArray),
      ShasumArray = std.contract.from_validator (fun arr => (if (functions.isValidShasumArray arr) then 'Ok else 'Error { message = "hello", notes = "[notes here]" })),

      # pkgs=import "pkgsRecord.ncl",
      Package = {
        # others
        # busybox,
        #vars
        baseName | String | optional,
        name | String | default
          =
            if ((stage == "final") || (stage == -1)) then
              baseName
            else
              "%{baseName}-stage-%{ std.to_string stage}",
        drvHash | force
          =
            let _name = name
            in
            let _bs = buildInputs
            in
            let _sis = sourceInputs in
            let _pds = patches in
            let _efs = extraFiles in
            let _sc = scriptContent in
            let _bic = buildInChroot in
            let _ec = enableCcache in
            drvUtils.pkgToHash {
              name = _name,
              buildInputs = _bs,
              sourceInputs = _sis,
              patches = _pds,
              extraFiles = _efs,
              scriptContent = _sc,
              buildInChroot = _bic,
              enableCcache = _ec,
            },
        options | default = {},

        isStatic | Bool | default = true,
        isLlvm | Bool | default = true,
        buildInputs
          | not_exported
          | std.contract.from_validator (fun arr =>
            (
              if (functions.isValidShasumArray (std.array.map (fun x => x.drvHash) arr)) then
                'Ok
              else
                'Error {
                  message =
                    "%{name} has invalid buildInputs\n"
                    ++ "        The buildInputs specified as packages are:\n        %{ std.string.join "\n        " (std.array.sort std.string.compare(std.array.map (fun x=> (x.name  )) (biPkgs @ baseBuildinputPackages ))) }"
                }
            )
          )
          | default
          = (biMap (biPkgs)) @ baseBuildinputPackages @ biDrvs,
        hasValidBuildInputs = (
          functions.isValidShasumArray (
            std.array.map
              (fun x => x.drvHash)
              buildInputs
          )
        ),
        utilsProviders | not_exported | Array Dyn | default = if (stage == -1) then (biMap [pkgs.busybox]) else [],
        baseBuildinputPackages | not_exported | Array Dyn | default = utilsProviders,
        biPkgs | Array Dyn | not_exported | default = [],
        biDrvs | Array { name | String, drvHash | String } | not_exported | default = [],

        # buildInputNames | Array String | default = [],
        buildDir | nullOrString | default = null,
        buildEnv | BuildEnv | default
          = {
            _stage = stage,
            _isLlvm = isLlvm,
            _isStatic = isStatic,
          },

        extraEnv | { _ : StringOrArray } | default
          = (
            if buildInChroot then
              {}
            else
              {
                LIBDIR = "/tmp/workdir/sysroot/usr/lib",
                PATH = "/tmp/workdir/sysroot/usr/bin:${PATH}",
                SYSROOT = "/tmp/workdir/sysroot",
              }
          ),

        unpackPhase | Array String | default
          = [
            if (std.array.length sourceInputs) == 0 then
              ""
            else
            # TODO: these should be joined by newlines
              m%"
      %{shellFunctions.unpackMaybe}
      %{std.string.join " " ( std.array.map (fun x => let dest =if ((std.record.has_field "dest" x)==false) then "" else x.dest in
      m%"
      mkdir -p /tmp/workdir/src/%{dest}
      unpack_maybe /tmp/workdir/packed/%{x.src.sha256sum}/%{dest} /tmp/workdir/src/%{dest}
      "%
        ) sourceInputs )}
      "%
          ],
        envSetupPhase =
          [
            "export WORKDIR=/tmp/workdir",
            "export SRC=/tmp/workdir/src",
          ]
          @ (
            if (buildEnv.TARGET == buildEnv.HOST) then
              [
                "export DEST=/tmp/workdir/out/destdir",
              ]
            else
              [
                "mkdir /tmp/workdir/out/destdir/%{buildEnv.TARGET}",
                "export DEST=/tmp/workdir/out/destdir/%{buildEnv.TARGET}",
              ]
          )
          @ [
            "export BUILDDIR=/tmp/workdir/build"
          ]
          @ (std.record.values (std.record.map (fun field value => "export %{field}=%{functions.varToExportvar value}\n") (functions.getFinalBuildEnv buildEnv)))
          @ (std.record.values (std.record.map (fun field value => "export %{field}=%{functions.varToExportvar value}\n") extraEnv))

        # @ (functions.createExport "CC" buildEnv)
        ,
        patchPhase | Array String | default
          =
            if (std.array.length patches) == 0 then
              []
            else
              (std.array.map (fun p => "(cd ${SRC}; patch -p1 < /tmp/workdir/patches/%{p.file})") patches),
        preConfigurePhase | Array String | default = [],
        configurePhase | Array String | default = (if (buildDir == null) then [] else ["cd %{buildDir}"]),
        preBuildPhase | Array String | default = [],
        buildPhase | Array String | default = [],
        preInstallPhase | Array String | default = [],
        installPhase | Array String | default = [],
        postInstallPhase | Array String | default = [],
        phases | Array (Array String) | default = [unpackPhase, envSetupPhase, patchPhase, cdBuildPhase, preConfigurePhase, configurePhase, preBuildPhase, buildPhase, preInstallPhase, installPhase, postInstallPhase],

        cdBuildPhase | Array String = if separateBuildDir then [] else ["cd ${SRC}"],
        separateBuildDir | Bool | default = true,
        commands | Array String | default = std.array.flatten phases,
        scriptContent | String | force = "#!/bin/sh -e\n" ++ std.string.join "\n" commands,

        singleSource | Dyn | default = null,
        sourceInputs | not_exported | Array SourceInput | default = if (singleSource == null) then [] else [{ src = singleSource }],
        patchDir | String | default = "%{name}/patches",
        filesDir | String | default = "%{name}/files",
        patches | Array { file | String, sha256sum | String, uri | String | optional } | default = [],
        extraFiles | Array { file | String, sha256sum | String, uri | String | optional } | default = [],

        enableParallel | Bool | default = true,
        enableCcache | Bool | default = true,
        buildInChroot | Bool | default = (stage != 0),
        stage | Number | default = -1,
      },
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
          separateBuildDir|priority -1000=false,

          baseBuildinputPackages | priority -1000
            =
              utilsProviders
              @ lib.biMap (
                if (stage == -1) then
                  (
                    [pkgs.gnumake, pkgs.musl]
                    @ (if isLlvm then [pkgs.llvm] else [])
                    @ (if enableCcache then [pkgs.ccacheBin] else [])
                  )
                else
                  []
              ),

          buildPhase | priority -10
            = [
              "make " ++ (std.string.join " " makeArgs) ++ (if makeTargets == null then "" else " " ++ std.string.join " " makeTargets)
            ],
          installPhase | priority -10
            = [
              "make " ++ (std.string.join " " makeInstallArgs) ++ " " ++ (std.string.join " " makeInstallTargets)
            ]
        },

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
       let mapped = std.array.map (fun f => {flag  = f, value=std.record.get_or "%{f}" false r}) flagOpts in 
       # remove a flag by setting "--disable-shared"=null
       let filtered = std.array.filter (fun x=>x.value!=null) mapped in 
        let finalFlags = std.array.map (fun x =>  ( if x.value==false then x.flag else  "%{x.flag}=%{x.value}" )  ) filtered in 
        finalFlags
      ),

      AutotoolsPackage =
        MakePackage
        & {
          isStatic,
          buildDir,
          configureFlags | nullOrArray | default = constants.configureFlags @ (if isStatic then constants.configureFlagsStatic else []) @(configureFlagsFromRecord ( extraFlagsByField & extraConfigureFlagsByField  ) )  @ extraConfigureFlags,
          extraConfigureFlags | Array String | default = [],
          extraFlagsByField|default={},
          extraConfigureFlagsByField|default={},
          configureScript | String | default = "${SRC}/configure",
          separateBuildDir|priority -999=true,

          configurePhase | priority -11
            =
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
          configurePhase | priority -10
            =
              (if (buildDir == null) then [] else ["cd %{buildDir}"])
              @ [
                "(cd ${SRC}; autoreconf -fiv)",
                configureScript ++ " " ++ (std.string.join constants.buildFlagSep configureFlags),
              ],
          baseBuildinputPackages | priority -999
            =
              AutotoolsPackage.baseBuildinputPackages
              @ lib.biMap (
                if (stage == -1) then
                  [
                    pkgs.perl,
                    pkgs.automake,
                    pkgs.autoconf,
                    pkgs.m4,
                    pkgs.libtool,
                    pkgs.pkgconf,
                  ]
                else
                  []
              ),
        },
      MesonPackage =
        Package
        & {
          isStatic,
          enableCcache,
          isLlvm,
          stage,
          utilsProviders,

          mesonArgs | nullOrArray | default = (baseMesonArgs @ extraMesonArgs),
          baseMesonArgs | Array String | default = constants.mesonArgs @ (if isStatic then constants.mesonArgsStatic else []),
          extraMesonArgs | Array String | default = [],
          configurePhase | priority -1000
            = [
              "meson setup %{std.string.join constants.buildFlagSep mesonArgs} . ${SRC}"
            ],
          buildPhase | priority -1000
            = [
              "meson compile"
            ],
          installPhase | priority -1000
            = [
              "meson install --destdir ${DEST}"
            ],

          baseBuildinputPackages | priority -1000
            =
              utilsProviders
              @ lib.biMap (
                if (stage == -1) then
                  (
                    [
                      pkgs.meson,
                      pkgs.samurai,
                      pkgs.pythonFull,
                      pkgs.pkgconf,
                      pkgs.musl,
                    ]
                    @ (if isLlvm then [pkgs.llvm] else [])
                    @ (if enableCcache then [pkgs.ccacheBin] else [])
                  )
                else
                  []
              ),
        },
      cmakeRecordFieldToCmakeArg = (fun k v =>
        let var = "-D%{k}" in
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

          enableParallel,
          cmakeArgs | Array String | default = constants.cmakeArgs @ (if isStatic then constants.cmakeArgsStatic else []) @ (cmakeArgsTransform (cmakeArgsRecord & cmakeExtraArgsRecord)) @ extraCmakeArgs,
          extraCmakeArgs | Array String | default = [],
          cmakeArgsRecord | default = {},
          cmakeExtraArgsRecord | default = {},

          generator | nullOrString | default = null,

          baseBuildinputPackages | priority -1000
            =
              utilsProviders
              @ lib.biMap (
                if (stage == -1) then
                  (
                    [
                      pkgs.cmake,
                      pkgs.pkgconf,
                      pkgs.musl,
                    ]
                    @ (if isLlvm then [pkgs.llvm] else [])
                    @ (if enableCcache then [pkgs.ccacheBin] else [])
                    @ (if (generator == "Ninja") then [pkgs.samurai] else [])
                  )
                else
                  []
              ),

          cmakeDir | String | default = "${SRC}",

          configurePhase | priority -10 = ["cmake -B . -S %{cmakeDir} %{std.string.join constants.buildFlagSep cmakeArgs}"],
          buildPhase | priority -10 = ["cmake --build ."],
          installPhase | priority -10 = ["DESTDIR=${DEST} cmake --install ."],
          extraEnv | priority -10
            =
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
      SetuptoolPackage =
        Package
        & {
          stage,
          pythonExecutable | String | default = "python",
          buildPhase | priority -5
            = [
              "cd ${SRC}",
              "%{pythonExecutable} setup.py build",
            ],
          installPhase | priority -5
            = [
              "%{pythonExecutable} setup.py install --prefix=/usr --root=${DEST} --skip-build"
            ],
          enableCcache | priority -1000 = false,
          baseBuildinputPackages | priority -1000
            =
              Package.baseBuildinputPackages
              @ lib.biMap (
                if (stage == -1) then
                  (
                    [
                      pkgs.pythonFull,
                      # pkgs.pkgconf,
                      # pkgs.musl,
                      pkgs.pythonSetuptools,
                    ]
                    # @ (if isLlvm then [pkgs.llvm] else [])
                    @ (if enableCcache then [pkgs.ccacheBin] else [])
                  )
                else
                  []
              ),
        },

      Src = {
        uri | nullOrString | default = null,
        sha256sum | String | default = "",
      },
      SourceInput = {
        src | Src,
        dest | String | optional,
      },
    }
}
