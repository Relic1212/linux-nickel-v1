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
  dest | String | default = "",
}
in
let lib = {
  computeSha256 = (fun s => (std.hash 'Sha256) s),
  BuildEnv = {
    cc | nullOrString | default = null,
    ccp | nullOrString | default = null,
    cxx | nullOrString | default = null,
    ar | nullOrString | default = null,
    nm | nullOrString | default = null,
    ranlib | nullOrString | default = null,
    objdum | nullOrString | default = null,
    objcopy | nullOrString | default = null,
    ld | nullOrString | default = null,
    cflags | nullOrArray | default = null,
    cppflags | nullOrArray | default = null,
    cxxflags | nullOrArray | default = null,
    ldflags | nullOrArray | default = null,
  },
  Src = _Src,

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
    buildEnv | BuildEnv | default = nullEnv,
    commands | Array String | default = [],
    srcs | Array Dyn | default = [],
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
