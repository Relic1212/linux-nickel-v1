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

  rust,
  muslShared,
  pkgconf,
  clangCc,
  busybox,
  llvm,
  gnumake,
  musl,
  ccacheBin,
  perl,
  automake,
  autoconf,
  m4,
  libtool,
  pythonFull,
  meson,
  samurai,
  cmake,
  pythonSetuptools,

  lib =
    (import "buildEnv.ncl")
    & {
      BuildEnv,
      shellFunctions = import "./shellFunctions.ncl",
      # biMap = (fun arr => std.array.map (fun x => drvUtils.pkgToHash x) arr),
      singleBiMap = (fun x =>  ( if (
        # true
        # x.name != "NULL" 
       std.record.get_or  "buildInputsEvaluated" false x
      ) then (  { name = x.name, drvHash = x.drvHash }) else { name = x.name, drvHash = "204a9243c33380ce82fc6019dabcafc010a66c9b2a6cb0f99005b048248f08c5" }) ),
      # singleBiMap = (fun x => x),
      biMap = (fun arr => std.array.map (singleBiMap) arr),

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
      BuildInputC = std.contract.from_validator (fun x => (if ((std.record.has_field "buildInputs" x) == false) then 'Ok else 'Error { message = "name: \"%{x.name}\"", notes = "failure" })),
      _BuildInput = {
        name,
        drvHash,
        priority | optional,
        ..
      },
      BuildInput = std.contract.any_of [Number, _BuildInput],
      Package = {
        # others
        # busybox,
        #vars
        baseName | not_exported | String | default = "WRONG",
        name | String | default  = "NULL",
        # default = 
        #   if ((stage == "final") || (stage == -1)) then
        #     baseName
        #   else
        #     "%{baseName}-stage-%{ std.to_string stage}",
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
          drvUtils.pkgToHash {
            name = _name,
            buildInputsValidated = _bs,
            sourceInputs = _sis,
            patches = _pds,
            extraFiles = _efs,
            scriptContent = _sc,
            buildInChroot = _bic,
            enableCcache = _ec,
            symlinkBuldInputs = _sbi,
          },
        options | default = {},

        isStatic | Bool | default = true,
        isLlvm | Bool | default = true,
        buildInputsValidated
          # | not_exported
          # | std.contract.from_validator (fun arr =>
          #   (
          #     if (functions.isValidShasumArray (std.array.map (fun x => x.drvHash) arr)) then
          #       'Ok
          #     else
          #       'Error {
          #         message =
          #           "%{name} has invalid buildInputs\n"
          #           ++ "        The buildInputs specified as packages are:\n        %{ std.string.join "\n        " (std.array.sort std.string.compare(std.array.map (fun x=> (x.name  )) ( baseBuildinputPackages ))) }"
          #       }
          #   )
          # )
          | force
          = buildInputs,
        
        buildInputsEvaluated  = std.array.fold_left (&&) true (std.array.map (fun x => ( std.is_number x )==false) buildInputsValidated),

        buildInputs | Array BuildInput | not_exported | default =
          baseBuildinputPackages @ biDrvs,

        hasValidBuildInputs | not_exported = (
          functions.isValidShasumArray (
            std.array.map
              (fun x => x.drvHash)
              buildInputsValidated
          )
        ),
        utilsProviders | not_exported | Array BuildInput | default = if (stage == -1) then (lib.biMap [busybox]) else [],
        llvmProvider | BuildInput | not_exported | default = singleBiMap llvm,
        baseBuildinputPackages | not_exported | Array BuildInput | default = utilsProviders,
        # biPkgs | Array Dyn | not_exported | default = [],
        # biDrvs | Array { name | String, drvHash | String, priority | Number | optional } | not_exported | default = [],
        biDrvs | Array BuildInput | not_exported | default = [],

        # buildInputNames | Array String | default = [],
        buildDir | nullOrString | default = null,
        buildEnv | BuildEnv | default = {
          _stage = stage,
          _isLlvm | force = isLlvm,
          _isStatic = isStatic,
        },
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
          separateBuildDir | priority -1000 = false,
          llvmProvider | not_exported,
          baseBuildinputPackages | priority -1000 =
            utilsProviders
            @ lib.biMap (
              if (stage == -1) then
                (
                  [gnumake, musl]
                  @ (if isLlvm then [llvmProvider] else [])
                  @ (if enableCcache then [ccacheBin] else [])
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
          perlProvider | BuildInput | not_exported | default = singleBiMap perl,
          baseBuildinputPackages | priority -999 =
            AutotoolsPackage.baseBuildinputPackages
            @ lib.biMap (
              if (stage == -1) then
                [
                  perlProvider,
                  automake,
                  autoconf,
                  m4,
                  libtool,
                  pkgconf,
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
          pythonProvider | BuildInput | default = singleBiMap pythonFull,
          baseBuildinputPackages | priority -1000 =
            utilsProviders
            @ lib.biMap (
              if (stage == -1) then
                (
                  [
                    meson,
                    samurai,
                    pythonProvider,
                    pkgconf,
                    musl,
                  ]
                  @ (if isLlvm then [llvmProvider] else [])
                  @ (if enableCcache then [ccacheBin] else [])
                )
              else
                []
            ),
        },
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
          llvmProvider,

          enableParallel,
          cmakeArgs | Array String | default =
            cmakeArgsPrepend
            @ (
            # std.array.sort (std.string.compare)
            (
              cmakeArgsTransform (
                constants.cmakeArgsByField
                & (if isStatic then constants.cmakeArgsStaticByField else {})
                & cmakeArgsRecord
                & cmakeExtraArgsRecord
              )
            )
            )
            @ extraCmakeArgs,
          cmakeArgsPrepend | Array String | default = [],

          extraCmakeArgs | Array String | default = [],
          cmakeArgsRecord | default = {},
          cmakeExtraArgsRecord | default = {},

          generator | nullOrString | default = null,

          baseBuildinputPackages | priority -1000 =
            utilsProviders
            @ lib.biMap (
              if (stage == -1) then
                (
                  [
                    cmake,
                    pkgconf,
                    musl,
                  ]
                  @ (if isLlvm then [llvmProvider] else [])
                  @ (if enableCcache then [ccacheBin] else [])
                  @ (if (generator == "Ninja") then [samurai] else [])
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
      SetuptoolPackage =
        Package
        & {
          stage,
          pythonExecutable | String | default = "python",
          buildPhase | priority -5 = [
            "cd ${SRC}",
            "%{pythonExecutable} setup.py build",
          ],
          installPhase | priority -5 = [
            "%{pythonExecutable} setup.py install --prefix=/usr --root=${DEST} --skip-build"
          ],
          enableCcache | priority -1000 = false,
          baseBuildinputPackages | priority -1000 =
            Package.baseBuildinputPackages
            @ lib.biMap (
              if (stage == -1) then
                (
                  [
                    pythonFull,
                    # pkgconf,
                    # musl,
                    pythonSetuptools,
                  ]
                  # @ (if isLlvm then [llvm] else [])
                  @ (if enableCcache then [ccacheBin] else [])
                )
              else
                []
            ),
        },

      Src = {
        uri | nullOrString | default = null,
        sha256sum | String | default = "",
      },
      SourceInput | not_exported = {
        src | Src,
        dest | String | optional,
        unpack | Bool | optional,
      },
    },

  ########### rust

  lib = {

    Package,
    SourceInput,

    functions = {
      importCrate = (fun j =>
        let crate | Crate = {
          name | default = std.record.get_or "name" "NULL" j,
          version | default = std.record.get_or "version" "NULL" j,
          sha256sum | default = std.record.get_or "checksum" "NULL" j,
          meta = {
            source | default = std.record.get_or "source" "NULL" j,
          }
        }
        in
        crate
      ),
      importCrates = (fun js =>
        std.array.map
          (fun j =>
            let _crate = importCrate j in
            {
              # "%{j.name}-%{j.version}"
              "%{_crate.name}" = { "%{_crate.version}" = _crate },
            }
          )
          js
        |> std.record.merge_all
      ),

      importCargoLock = (fun toml => ((importCrates (toml.package)))),

      filterCrates = (fun j =>
        let _crates = std.record.map (fun c v => std.record.filter (fun ver val => val.sha256sum != "NULL") v) ((lib.functions.importCrates) j)
        in _crates
      ),
    },

    # rust,
    # muslShared,
    # pkgconf,
    # llvmProvider,
    # clangCc,

    CargoPackage =
      Package
      & {
        utilsProviders,
        llvmProvider,
        singleSource,
        buildEnv,
        target = (if buildEnv.TARGET == null then "x86_64-unknown-linux-musl" else buildEnv.TARGET),
        extraEnv = {
          STATIC_RUSTFLAGS | default = [
            "-C target-feature=+crt-static",
            "-C link-self-contained=yes",
            "-C link-arg=-static",
            "-C link-arg=--static"
          ],
          EXTRA_RUSTFLAGS | default = [],
          RUSTFLAGS | default = STATIC_RUSTFLAGS @ EXTRA_RUSTFLAGS,
        },

        baseBuildinputPackages | priority -1000 =
          lib.biMap [
            rust,
            muslShared,
            pkgconf,
            llvmProvider,
            clangCc,
          ]
          @ utilsProviders,

        enableCcache | priority -1000 = false,
        separateBuildDir | priority -1000 = false,
        extraCargoFlags | Array String | default = [],
        release | Bool | default = true,
        preConfigurePhase | priority -1000 = [
          m%"
            for d in $(ls  ${SRC}/vendor); do
              if [ -e ${SRC}/vendor/${d}/download ]; then
                mv  ${SRC}/vendor/${d}/download  ${SRC}/vendor/${d}/download.tar.gz
                tar -xf ${SRC}/vendor/${d}/download.tar.gz --strip-components=1 -C ${SRC}/vendor/${d}/
                echo '{"package":"'"$(sha256sum ${SRC}/vendor/${d}/download.tar.gz|cut -d ' ' -f1)"'","files":{}}' >  ${SRC}/vendor/${d}/.cargo-checksum.json
              fi
            done
            "%,
          "mkdir -p ${SRC}/.cargo",
          m%"
            echo "

            [source.crates-io]
            replace-with = \"vendored-sources\"

            [source.vendored-sources]
            directory = \"vendor\"

            " >> ${SRC}/.cargo/config.toml
            "%,
          "export CARGO_HOME=${SRC}/.cargo",
        ],
        releaseFlags | default =
          if release then
            [
              "--release",
            ]
          else
            [],
        baseCargoFlags | default = [
          "--offline",
          "--target %{target}"
        ],
        cargoFlags | default = releaseFlags @ baseCargoFlags @ extraCargoFlags,
        buildPhase | priority -1000 = [
          "cargo build %{std.string.join "\t\\\n" cargoFlags}"
        ],
        artefactDir | default = if release then "${SRC}/target/%{target}/release" else "${SRC}/target/%{target}/debug",

        installPhase | priority -1000 = [
          "install -d -m0755 ${DEST}/usr/bin",
          m%"
          for f in $(ls %{artefactDir}); do
            file_end=$(echo $f| rev | cut -d '.' -f1|rev)

            if [ -f "%{artefactDir}/${f}" ] \
              && [ ! "$file_end" = "d" ] \
              && [ ! "$file_end" = "rlib" ]; then

              install -m0755 "%{artefactDir}/${f}" \
                ${DEST}/usr/bin

            fi
          done
          "%
        ],

        nonCrateSourceInputs | not_exported | Array SourceInput | default = if (singleSource == null) then [] else [{ src = singleSource }],

        lockfileImport | default = null,
        crates | default = if (lockfileImport == null) then {} else (lib.functions.importCargoLock lockfileImport),

        cratesArray | not_exported | default = std.array.flatten (std.array.map (std.record.values) (std.record.values crates)),

        crateSourceInputs | not_exported | Array SourceInput | default = (std.array.map (fun c => c.sourceInput) cratesArray),

        sourceInputs | priority -1000 = nonCrateSourceInputs @ crateSourceInputs,
      },

    Crate = {
      name | String,
      version | String,
      uri | String | default = "https://crates.io/api/v1/crates/%{name}/%{version}/download",
      sha256sum | String,
      meta = {
        source | String | optional,
        dependencies | optional,
      },
      unpackCommands | Array String | default = [
        "mkdir -p ${SRC}/vendor/%{name}",
        "(cd  ${SRC}/vendor/%{name}; tar -xf /tmp/packed/%{sha256sum}/download --strip-components=1)",
      ],

      sourceInput | default = {
        dest = "vendor/%{name}-%{version}",
        src =
          let _uri = uri in
          let _sha = sha256sum in
          {
            uri | priority -1 = _uri,
            sha256sum | priority -1 = _sha,
          }
      }
    }
  }
}
