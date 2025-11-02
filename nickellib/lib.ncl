let constants = import "./constants.ncl"
in
let _constants = constants
# in
# let shellFunctions = import "./shellFunctions.ncl"
in
let drvUtils = import "drv.ncl"
in

{
  # pkgs, #| default = import "pkgsRecord.ncl",
  # hashByName,
  drvs,
  pkgs,

  lib =
    (import "buildEnv.ncl")
    & {
      BuildEnv,
      staticEnv,
      llvmEnv,
      staticLlvmEnv,
      shellFunctions = import "./shellFunctions.ncl",
      # biMap = (fun arr => std.array.map (fun x => drvUtils.pkgToHash x) arr),
      biMap = (fun arr => std.array.map (fun x => { name = x.name, drvHash = x.drvHash }) arr),

      # biMap2 = (fun arr => std.array.map (fun x => (hashByName."%{x}") ) arr),

      constants = _constants,
      functions | not_exported = {
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
        baseName | not_exported | String | optional,
        name | String | default =
          if ((stage == "final") || (stage == -1)) then
            baseName
          else
            "%{baseName}-stage-%{ std.to_string stage}",
        drvHash | force =
          let _name = name
          in
          let _bs = buildInputsValidated
          in
          let _sis = sourceInputs in
          let _pds = patches in
          let _efs = extraFiles in
          let _sc = scriptContent in
          let _bic = buildInChroot in
          let _ec = enableCcache in
          let _sbi = symlinkBuldInputs in
          let df = deterministicFetcher, of = outputFile, oss = outputSha256sum in
          drvUtils.pkgToHash (std.record.freeze {
            name = _name,
            buildInputsValidated = _bs,
            sourceInputs = _sis,
            patches = _pds,
            extraFiles = _efs,
            scriptContent = _sc,
            buildInChroot = _bic,
            enableCcache = _ec,
            symlinkBuldInputs = _sbi,
            deterministicFetcher = df,
            outputFile = of,
            outputSha256sum = oss
          }),
        options | default = {},
        deterministicFetcher | Bool | default = false,
        outputFile | String | default = "",
        outputSha256sum | String | default = "",

        isStatic | Bool | default = true,
        isLlvm | Bool | default = true,
        debug | Bool | default = false,
        useMimalloc | default = false,
        buildInputsValidated
          | not_exported
          | std.contract.from_validator (fun arr =>
            (
              if (
                # functions.isValidShasumArray (std.array.map (fun x => x.drvHash) arr)
                functions.hasNoDups arr
                # true
              ) then
                'Ok
              else
                'Error {
                  message =
                    "%{name} has invalid buildInputs\n"
                    ++ "        The buildInputs specified as packages are:\n        %{ std.string.join "\n        " (std.array.sort std.string.compare(std.array.map (fun x=> (x.name  )) ( baseBuildinputPackages ))) }"
                }
            )
          )
          | force
          = buildInputs,

        # with changing configurations, propageted could cause a lot of issues.
        allowDubplicateBuldInputs | Bool | default = false,

        buildInputs | not_exported | default =
          let maybeDups =
            baseBuildinputPackages
            @ biDrvs
            @ propagatedBuildInputs
            @ indirectDeps
          in
          if (!allowDubplicateBuldInputs) then
            maybeDups
          else
            std.array.dedup maybeDups,
        propagatedBuildInputs | default = [],
        indirectDeps | default =
          let depKeyNames = std.array.map (fun v => v.keyName) (propagatedBuildInputs) in
          let depPkgs = std.array.map (fun k => pkgs."%{k}") depKeyNames in
          let ll = std.array.map (fun pkg => pkg.propagatedBuildInputs @ pkg.indirectDeps) depPkgs in
          let l = std.array.flatten ll in
          std.array.dedup l,
        hasValidBuildInputs | not_exported = (
          functions.isValidShasumArray (
            std.array.map
              (fun x => x.drvHash)
              buildInputsValidated
          )
        ),
        utilsProviders | not_exported | Array Dyn | default = if (stage == -1) then ([drvs.busybox]) else [],
        llvmProvider | not_exported | default = drvs.llvm,
        llvmProviders | not_exported | default = [llvmProvider] @ (if buildEnv._isMold then [drvs.mold] else []),
        muslProvider | not_exported | default = if (!debug) then drvs.musl else drvs.muslDebug,
        muslProviders | default = if (!useMimalloc) then [muslProvider] else [drvs.muslProvider, drvs.mimalloc],

        # pkgconfProvider | not_exported | default = drvs.pkgconf,
        pkgconfProvider | not_exported | default = drvs.pkgconfMeson,

        baseBuildinputPackages | not_exported | Array Dyn | default = utilsProviders,
        # biPkgs | Array Dyn | not_exported | default = [],
        # biDrvs | Array { name | String, drvHash | String, priority | Number | optional } | not_exported | default = [],
        biDrvs | Array Dyn | not_exported | default = [],

        # buildInputNames | Array String | default = [],
        buildDir | nullOrString | default = null,
        buildEnv | BuildEnv | default = {
          _stage = stage,
          _isLlvm | force = isLlvm,
          _isStatic = isStatic,
          _debug | force = debug,
        },
        buildEnv._debug | priority -1000 = debug,
        buildEnv._isStatic | priority -1000 = isStatic,
        symlinkBuldInputs | Bool | default = false, # stage==-1,
        extraEnv | { _ : StringOrArray } | default = (
          if buildInChroot then
            {}
          else
            {
              LIBDIR = "/tmp/workdir/sysroot/usr/lib",
              PATH = "/tmp/workdir/sysroot/usr/bin:${PATH}",
              SYSROOT = "/tmp/workdir/sysroot",
            }
        ),

        unpackPhase | Array String | default = [
          if (std.array.length sourceInputs) == 0 then
            ""
          else
            # TODO: these should be joined by newlines
            # Fixed
            m%"
      %{shellFunctions.unpackMaybe}
      %{std.string.join "\n" ( std.array.map (fun x => let dest =if ((std.record.has_field "dest" x)==false) then "" else x.dest in
      m%"
      mkdir -p /tmp/workdir/src/%{dest}
      unpack_maybe /tmp/workdir/packed/%{x.src.sha256sum}/%{dest} /tmp/workdir/src/%{dest}
      "%
        )
        ( std.array.filter (fun si => (std.record.get_or "unpack" true si) ) sourceInputs ) )}
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
        ,patchPhase | Array String | default =
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
        enableCcache | Bool | default = buildInChroot,
        buildInChroot | Bool | default = (stage != 0),
        stage | Number | default = -1,
      },

      Src = {
        uri | nullOrString | default = null,
        sha256sum | String | default = "",
      },
      SourceInput = {
        src | Src,
        dest | String | optional,
        unpack | Bool | optional,
      },
    }
}
& (import "packagetypes/MakePackage.ncl")
& (import "packagetypes/AutotoolsPackage.ncl")
& (import "packagetypes/MesonPackage.ncl")
& (import "packagetypes/CmakePackage.ncl")
& (import "packagetypes/SetuptoolPackage.ncl")
& (import "packagetypes/DeterministicFetcher.ncl")
