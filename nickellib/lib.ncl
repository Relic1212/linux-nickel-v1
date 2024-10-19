let constants = import "./constants.ncl"
in
let shellFunctions= import "./shellFunctions.ncl"
in
let lib = {
  functions = {
    computeSha256 = (fun s => (std.hash 'Sha256) s),
    recordToHash = fun r => computeSha256 (std.serialize 'Json r),
    isNullOrString = (fun s => std.is_string s || s == null),
    nullOrString = std.contract.from_predicate (isNullOrString),
    isNullArray = (fun a => std.is_array a || a == null),
    nullOrArray = std.contract.from_predicate (isNullArray),
    varToExportvar=(fun var => if ((std.typeof var )== '"String") then var else 
    "\"" + (std.string.join " " var) + "\"" 
    ),
    createExport=(fun key env => (if (std.record.has_field key env) then ["export %{key}=%{varToExportvar env."%{key}"}"] else []) )
  },
  nullOrString = std.contract.from_predicate (functions.isNullOrString),

  nullOrArray = std.contract.from_predicate (functions.isNullArray),

  BuildEnv = {
    CC | nullOrString | optional,
    CCP | nullOrString | optional,
    CXX | nullOrString | optional,
    AR | nullOrString | optional,
    NM | nullOrString | optional,
    RANLIB | nullOrString | optional,
    OBJDUMP | nullOrString | optional,
    OBJCOPY | nullOrString | optional,
    LD | nullOrString | optional,
    CFLAGS | nullOrArray | optional,
    CPPFLAGS | nullOrArray | optional,
    CXXFLAGS | nullOrArray | optional,
    LDFLAGS | nullOrArray | optional,
  },

  nullEnv | BuildEnv
    = {},
  staticEnv | BuildEnv
    =
      let common_flags = constants.staticFlags in
      {
        CFLAGS = common_flags,
        CXXFLAGS = common_flags,
        LDFLAGS = common_flags,
      },
  Package = {
    name | Dyn | default = null,
    buildInputs | Array Dyn | default = [],
    buildEnv | BuildEnv | default = if isStatic then staticEnv else nullEnv,
    unpackPhase | Array String | default
      = [
        if (std.array.length sourceInputs) == 0 then
          ""
        else
          m%"
      %{shellFunctions.unpackMaybe}
      for dest in %{std.string.join " " ( std.array.map (fun x => if x.dest==null then "" else x.dest  ) sourceInputs )} do
        mkdir -p /tmp/workdir/src/${dest}
        cp -r /tmp/workdir/unpacked/${dest} /tmp/workdir/src/${dest}
      done
      "%
      ],
    envSetupPhase=[
      "export WORKDIR=/tmp/workdir",

      "export SRC=/tmp/workdir/src",
      "export DEST=/tmp/workdir/dest",
      "export BUILDDIR=/tmp/workdir/build"

    ]@
    (functions.createExport "CC" buildEnv)
    
    ,
    patchPhase | Array String | default
      = 
        if (std.array.length patches) == 0 then
          []
        else [
          m%"      "export SRC=/tmp/workdir/src"

      for p in %{std.string.join " " patches} do
        (cd ${SRC}; patch -p1 < ${p})
      done
      "%
      ],
    configurePhase | Array String | default = [],
    buildPhase | Array String | default = [],
    installPhase | Array String | default = [],
    phases | Array (Array String) | default = [unpackPhase, envSetupPhase ,patchPhase, configurePhase, buildPhase, installPhase],

    commands | Array String | default = std.array.flatten phases,
    scriptContent | String | default = "#!/bin/sh -e\n"++ std.string.join "\n" commands,

    sourceInputs | Array SourceInput | default = [],
    patchDir | String | default = "patches",
    filesDir | String | default = "files",
    patches | Array String | default = [],
    extraFiles | Array String | default = [],
    isStatic | Bool | default = true,
    isLlvm|Bool|default=true,
    enableParallel|Bool|default=true,
    enableCcache|Bool|default=true,
    buildInChroot|Bool|default=true
  },
  MakePackage =
    Package
    & {
      enableParallel|default=Package.enableParallel,
      makeArgs | nullOrArray | default = ["PREFIX=/usr"] @ (if enableParallel then  ["-j$(nproc)"] else []),
      makeTargets | nullOrArray | default = null,
      makeInstallArgs | nullOrArray | default = ["DESTDIR=${out}"],
      makeInstallTargets | nullOrArray | default = ["install"],
      buildPhase | priority -10
        = [
          "make " ++ (std.string.join " " makeArgs) ++ (if makeTargets == null then "" else " " ++ std.string.join " " makeTargets)
        ],
      installPhase | priority -10
        = [
          "make " ++ (std.string.join " " makeInstallArgs) ++ " " ++ (std.string.join " " makeInstallTargets)
        ]
    },
  AutotoolsPackage =
    MakePackage
    & {
      isStatic|default=MakePackage.isStatic,
      configureFlags | nullOrArray | default = constants.configureFlags @ ( if isStatic then constants.configureFlagsStatic else [] ),
      configureScript|String|default= "${SRC}/configure",
      configurePhase|priority -1=[ 
        configureScript ++ " " ++ (std.string.join " " configureFlags )
      ]
    },
  MesonPackage =
    Package
    & {
      mesonArgs | nullOrArray | default = constants.mesonArgs
    },
  CmakePackage =
    Package
    & {
      cmakeArgs | nullOrArray | default = constants.cmakeArgs
    },

  basePackage | Package
    = {
      name = null,
      buildInputs = []
    },

  Src = {
    uri | nullOrString | default = null,
    sha256sum | String | default = "",
  },
  SourceInput = {
    src | Src,
    dest | String | default = "",
  },
}
in
lib
