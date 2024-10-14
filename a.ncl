let isNullOrString = (fun s => std.is_string s || s == null)
in

let nullOrString = std.contract.from_predicate (isNullOrString)
in
let isNullArray = (fun a => std.is_array a || a == null)
in
let nullOrArray = std.contract.from_predicate (isNullArray)
in
let BuildEnv = {
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
}
in
let Src = {
  uri | String,
  sha256sum | String | default = "",
  dest | String | default = ""
}
in

let nullEnv | BuildEnv
  = {}
  in
let Package = {
  name | Dyn | default = null,
  buildInputs | Array Dyn | default = [],
  buildEnv | BuildEnv | default = nullEnv,
  commands | Array String | default = [],
  srcs | Array Src | default = [],
}
in
let basePackage | Package
  = {
    name = null,
    buildInputs = []
  }
  in
let examplePackage = basePackage & { name | priority 1 = "example", buildInputs | force = [basePackage] }
in
let extendedExamplePackage = examplePackage & { name | priority 2 = "extendedExample" }
in
let lib = {
  _Package = Package,
  _Src = Src,
  _basePackage = basePackage

}
in
{
    Package=lib._Package,
    basePackage=lib._basePackage,
}
# extendedExamplePackage
