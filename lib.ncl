let constants = import "constants.ncl"
in

let isNullOrString = (fun s => std.is_string s || s == null)
in

let nullOrString = std.contract.from_predicate (isNullOrString)
in
let isNullArray = (fun a => std.is_array a || a == null)
in
let nullOrArray = std.contract.from_predicate (isNullArray)
in

let _Src = {
  uri | nullOrString | default = null,
  sha256sum | String | default = "",
}
in
let 
 _SourceInput={
    src|_Src|default={ uri=null,sha256sum=""},
    dest|String|default="",
  }
in

let lib = {
  computeSha256 = (fun s => (std.hash 'Sha256) s),
  BuildEnv = {
    cc | nullOrString | optional,
    ccp | nullOrString | optional,
    cxx | nullOrString | optional,
    ar | nullOrString | optional,
    nm | nullOrString | optional,
    ranlib | nullOrString | optional,
    objdum | nullOrString | optional,
    objcopy | nullOrString | optional,
    ld | nullOrString | optional,
    cflags | nullOrArray | optional,
    cppflags | nullOrArray | optional,
    cxxflags | nullOrArray | optional,
    ldflags | nullOrArray | optional,
  },
  Src = _Src,
  SourceInput= _SourceInput,
  # {
  #   src|Dyn|default={ uri=null,sha256sum=""},
  #   dest|String|default="",
  # },

  nullEnv | BuildEnv
    = {},
  staticEnv | BuildEnv
    =
      let common_flags = constants.staticFlags in
      {
        cflags = common_flags,
        cxxflags = common_flags,
        ldflags = common_flags,
      },
  Package = {
    name | Dyn | default = null,
    buildInputs | Array Dyn | default = [],
    buildEnv | BuildEnv | default = if isStatic then staticEnv else nullEnv,
    commands | Array String | default = [],
    sourceInputs | Array SourceInput | default = [],
    isStatic|Bool|default=true,
  },
  MakePackage =
    Package
    & {
      makeArgs | nullOrArray | default = ["PREFIX=/usr", "-j$(nproc)"],
      makeTargets | nullOrArray | default = null,
      makeInstallArgs | nullOrArray | default = ["DESTDIR=${out}"],
      makeInstallTargets | nullOrArray | default = ["install"]
    },
  AutotoolsPackage =
    MakePackage
    & {
      configureFlags | nullOrArray | default = constants.configureFlags
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
  examplePackage =
    basePackage
    & {
      name | priority 1 = "example",
      buildInputs | force = [basePackage]
    },
  extendedExamplePackage =
    examplePackage
    & {
      name | priority 2 = "extendedExample"
    },
  recordToHash = fun r => computeSha256 (std.serialize 'Json r),
  packageToDrv = (fun p => p & { buildInputs | force = [] })
}
in
lib
