let constants = import "./constants.ncl"
in
let _constants=constants
in
let shellFunctions = import "./shellFunctions.ncl"
in
let lib = {
  constants=_constants,
  functions = {
    computeSha256 = (fun s => (std.hash 'Sha256) s),
    recordToHash = fun r => computeSha256 (std.serialize 'Json r),
    isNullOrString = (fun s => std.is_string s || s == null),
    isNullArray = (fun a => std.is_array a || a == null),
    isStringOrArray = (fun a => std.is_array a || std.is_string a),

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
    cmakeRecordToArgs=(fun r =>(std.record.values (std.record.map (fun field value => "-D%{field}=%{value}") r))),
    replaceArrayElem=(fun old new arr=>(std.array.map (fun elem=> (if (elem==old) then new else elem) ) arr)),
  },
  nullOrString = std.contract.from_predicate (functions.isNullOrString),

  nullOrArray = std.contract.from_predicate (functions.isNullArray),
  StringOrArray = std.contract.from_predicate (functions.isStringOrArray),

  BuildEnv = {
    CC | nullOrString | optional,
    CPP | nullOrString | optional,
    CXX | nullOrString | optional,
    AR | nullOrString | optional,
    AS | nullOrString | optional,

    NM | nullOrString | optional,
    RANLIB | nullOrString | optional,
    READELF | nullOrString | optional,
    OBJDUMP | nullOrString | optional,
    OBJCOPY | nullOrString | optional,
    LD | nullOrString | optional,
    CFLAGS | nullOrArray | optional,
    CPPFLAGS | nullOrArray | optional,
    CXXFLAGS | nullOrArray | optional,
    LDFLAGS | nullOrArray | optional,
    SOURCE_DATE_EPOCH | String | default = "\"1302044400\"",
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
  llvmEnv|BuildEnv={
    CC="clang",
    CPP="clang-cpp",
    CXX="clang++",
    AS="llvm-as",

    AR="llvm-ar",
    NM="llvm-nm",
    OBJCOPY="llvm-objcopy",
    OBJDUMP="llvm-objdump",
    RANLIB="llvm-ranlib",
    READELF="llvm-readelf",
    LDFLAGS=[ "-fuse-ld=lld", "-stdlib=libc++","-rtlib=compiler-rt", "-unwindlib=libunwind"],
    LD|default="lld",

  },
  staticLlvmEnv = functions.joinMerge staticEnv llvmEnv,
  Package = {
    name | String,
    buildInputs | Array Dyn | default = [],
    buildDir|nullOrString|default=null,
    buildEnv | BuildEnv | default = 
    
    ((if (isStatic && isLlvm) then (staticLlvmEnv) else (if isStatic then staticEnv else if isLlvm then (llvmEnv) else nullEnv))&( if ((isLlvm && buildInChroot) && (stage!=0) ) then {  } else {}  ))
    ,
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
        "export DEST=/tmp/workdir/out/destdir",
        "export BUILDDIR=/tmp/workdir/build"
      ]
      @ (std.record.values (std.record.map (fun field value => "export %{field}=%{functions.varToExportvar value}\n") buildEnv))
      @ (std.record.values (std.record.map (fun field value => "export %{field}=%{functions.varToExportvar value}\n") extraEnv))

    # @ (functions.createExport "CC" buildEnv)
    # @ (functions.createExport "CXX" buildEnv)
    # @ (functions.createExport "CPP" buildEnv)
    # @ (functions.createExport "AR" buildEnv)
    # @ (functions.createExport "NM" buildEnv)
    # @ (functions.createExport "RANLIB" buildEnv)
    # @ (functions.createExport "OBJCOPY" buildEnv)
    # @ (functions.createExport "OBJDUMP" buildEnv)
    # @ (functions.createExport "CC" buildEnv)
    # @ (functions.createExport "LD" buildEnv)
    # @ (functions.createExport "CFLAGS" buildEnv)
    # @ (functions.createExport "CPPFLAGS" buildEnv)
    # @ (functions.createExport "CXXFLAGS" buildEnv)
    # @ (functions.createExport "LDFLAGS" buildEnv)
    # @

    # @ (if buildInChroot then [] else [
    #   "export LIBDIR=/tmp/workdir/sysroot/usr/lib",
    #   "export PATH=/tmp/workdir/sysroot/usr/bin:${PATH}",
    #   "export SYSROOT=/tmp/workdir/sysroot"
    #   ])
    ,
    patchPhase | Array String | default
      =
        if (std.array.length patches) == 0 then
          []
        else
          (std.array.map (fun p=> "(cd ${SRC}; patch -p1 < /tmp/workdir/patches/%{p.file})") patches)
      ,
    configurePhase | Array String | default = ( if (buildDir==null) then [] else ["cd %{buildDir}"]),
    buildPhase | Array String | default = [],
    installPhase | Array String | default = [],
    phases | Array (Array String) | default = [unpackPhase, envSetupPhase, patchPhase, configurePhase, buildPhase, installPhase],

    commands | Array String | default = std.array.flatten phases,
    scriptContent | String | default = "#!/bin/sh -e\n" ++ std.string.join "\n" commands,

    sourceInputs | Array SourceInput | default = [],
    patchDir | String | default = "%{name}/patches",
    filesDir | String | default = "%{name}/files",
    patches | Array {file|String,sha256sum|String,uri|String|optional} | default = [],
    extraFiles | Array  {file|String,sha256sum|String,uri|String|optional}  | default = [],
    isStatic | Bool | default = true,
    isLlvm | Bool | default = true,
    enableParallel | Bool | default = true,
    enableCcache | Bool | default = true,
    buildInChroot | Bool | default = (stage!=0),
    stage|default=-1,
  },
  MakePackage =
    Package
    & {
      enableParallel | default = Package.enableParallel,
      makeArgs | nullOrArray | default = ["PREFIX=/usr"] @ (if enableParallel then ["-j$(nproc)"] else []),
      makeTargets | nullOrArray | default = null,
      makeInstallArgs | nullOrArray | default = ["DESTDIR=${DEST}"],
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
      isStatic | default = MakePackage.isStatic,
      configureFlags | nullOrArray | default = constants.configureFlags @ (if isStatic then constants.configureFlagsStatic else []),
      configureScript | String | default = "${SRC}/configure",
      configurePhase | priority -1
        = [
          configureScript ++ " " ++ (std.string.join constants.buildFlagSep configureFlags)
        ]
    },
  MesonPackage =
    Package
    & {
      isStatic | default = Package.isStatic,

      mesonArgs | nullOrArray | default = constants.mesonArgs @ (if isStatic then constants.mesonArgsStatic else []),
    },
  CmakePackage =
    Package
    & {
      isStatic | default = Package.isStatic,
      buildInChroot | default = Package.buildInChroot,

      enableParallel | priority -10 = Package.enableParallel,
      cmakeArgs | Array String | default = constants.cmakeArgs @ (if isStatic then constants.cmakeArgsStatic else []),
      configurePhase | priority -10 = ["cmake -B . -S ${SRC} %{std.string.join constants.buildFlagSep cmakeArgs}"],
      buildPhase | priority -10 = ["cmake --build ."],
      installPhase | priority -10 = ["DESTDIR=${DEST} cmake --install ."],
      extraEnv | priority -10
        = (
           
           ( if buildInChroot then Package.extraEnv else (Package&{buildInChroot=false}).extraEnv)
          & (
            if enableParallel then
              { CMAKE_BUILD_PARALLEL_LEVEL = "$(nproc)" }
            else
              {}
          )
        )
    },

  basePackage | Package
    = {
      name = "null",
      buildInputs = []
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
in
lib
