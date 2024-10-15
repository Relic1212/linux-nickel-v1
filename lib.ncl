let constants = import "constants.ncl"
in

let lib = {
  functions = {
    computeSha256 = (fun s => (std.hash 'Sha256) s),
    recordToHash = fun r => computeSha256 (std.serialize 'Json r),
    isNullOrString = (fun s => std.is_string s || s == null),
    nullOrString = std.contract.from_predicate (isNullOrString),
    isNullArray = (fun a => std.is_array a || a == null),
    nullOrArray = std.contract.from_predicate (isNullArray),
  },
  nullOrString = std.contract.from_predicate (functions.isNullOrString),

  nullOrArray = std.contract.from_predicate (functions.isNullArray),

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
    isStatic | Bool | default = true,
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
