{
  constants,
  functions = {
    getFinalBuildEnv = (fun benv =>
      std.record.filter
        (fun k v =>
          (
          # only these values should be exported by the build
          (
            (
              std.array.elem
                k
                [
                  "CC",
                  "CPP",
                  "CXX",
                  "AR",
                  "AS",
                  "NM",
                  "RANLIB",
                  "READELF",
                  "OBJDUMP",
                  "OBJCOPY",
                  "LD",
                  "CFLAGS",
                  "CPPFLAGS",
                  "CXXFLAGS",
                  "LDFLAGS",
                  "SOURCE_DATE_EPOCH",
                ]
            )
            && (v != null)
          )
          )
        )
        benv
    ),

    flattenNullOrArray
      | doc m%"
    Takes an array of arrays or null values and if all elements are null returns null.
    Otherwise it returns the non-null elements flattened.
    Example:
    flattenNullOrArray [null, null, null] -> null
    flattenNullOrArray [[1,2], [3], null] -> [1,2,3]
    "%
      = (fun arrArr =>
        (
          if std.array.all (fun x => (x == null)) arrArr then
            null
          else
            ((std.array.filter (fun x => (x != null)) arrArr) |> std.array.flatten)
        )
      ),
  },
  nullOrString,
  nullOrArray,
  BuildEnv = {
    _isStatic | Bool | default = true,
    _isLlvm | Bool | default = true,
    _stage | Number,
    CC | nullOrString | default = if _isLlvm then "clang" else null,
    CPP | nullOrString | default = if _isLlvm then "clang-cpp" else null,
    CXX | nullOrString | default = if _isLlvm then "clang++" else null,
    AR | nullOrString | default = if _isLlvm then "llvm-ar" else null,
    AS | nullOrString | default = if _isLlvm then "llvm-as" else null,

    NM | nullOrString | default = if _isLlvm then "llvm-nm" else null,
    RANLIB | nullOrString | default = if _isLlvm then "llvm-ranlib" else null,
    READELF | nullOrString | default = if _isLlvm then "llvm-readelf" else null,
    OBJDUMP | nullOrString | default = if _isLlvm then "llvm-objdump" else null,
    OBJCOPY | nullOrString | default = if _isLlvm then "llvm-objcopy" else null,
    LD | nullOrString | default = if _isLlvm then "lld" else null,

    CFLAGS | nullOrArray | default = null,
    CPPFLAGS | nullOrArray | default = functions.flattenNullOrArray [BASE_CPPFLAGS, STATIC_CPPFLAGS, LLVM_CPPFLAGS, EXTRA_CPPFLAGS],
    CXXFLAGS | nullOrArray | default = null,
    LDFLAGS | nullOrArray | default = null,

    STATIC_CFLAGS | nullOrArray | default = if _isStatic then ["-static", "--static"] else null,
    STATIC_CPPFLAGS | nullOrArray | default = null,
    STATIC_CXXFLAGS | nullOrArray | default = if _isStatic then ["-static", "--static"] else null,
    STATIC_LDFLAGS | nullOrArray | default = if _isStatic then ["-static", "--static"] else null,

    BASE_CFLAGS | nullOrArray | default = null,
    BASE_CPPFLAGS | nullOrArray | default = null,
    BASE_CXXFLAGS | nullOrArray | default = null,
    BASE_LDFLAGS | nullOrArray | default = null,

    LLVM_CFLAGS | nullOrArray | default = if _isLlvm then ["-O2", "-pipe"] else null,
    LLVM_CPPFLAGS | nullOrArray | default = null,
    LLVM_CXXFLAGS | nullOrArray | default = if _isLlvm then ["-O2", "-pipe"] else null,
    LLVM_LDFLAGS | nullOrArray | default = if _isLlvm then ["-fuse-ld=lld", "-stdlib=libc++", "-rtlib=compiler-rt", "-unwindlib=libunwind"] else null,

    EXTRA_CFLAGS | nullOrArray | default = null,
    EXTRA_CPPFLAGS | nullOrArray | default = null,
    EXTRA_CXXFLAGS | nullOrArray | default = null,
    EXTRA_LDFLAGS | nullOrArray | default = null,

    SOURCE_DATE_EPOCH | String | default = "\"1302044400\"",
  },

  nullEnv | BuildEnv
    = {
      _isLlvm | default = false,
      _isStatic | default = false,
    },
  staticEnv | BuildEnv
    =
      let common_flags = constants.staticFlags in
      {
        _isStatic = true,
        _isLlvm | default = false,
        CFLAGS = common_flags,
        CXXFLAGS = common_flags,
        LDFLAGS = common_flags,
      },
  llvmEnv | BuildEnv
    = {
      _isLlvm = true,
      _isStatic | default = false,
      CC = "clang",
      CPP = "clang-cpp",
      CXX = "clang++",
      AS = "llvm-as",

      AR = "llvm-ar",
      NM = "llvm-nm",
      OBJCOPY = "llvm-objcopy",
      OBJDUMP = "llvm-objdump",
      RANLIB = "llvm-ranlib",
      READELF = "llvm-readelf",
      CFLAGS | priority -1 = ["-O2", "-pipe"],
      CXXFLAGS | priority -1 = ["-O2", "-pipe"],

      LDFLAGS | priority -1 = ["-fuse-ld=lld", "-stdlib=libc++", "-rtlib=compiler-rt", "-unwindlib=libunwind"],
      LD | priority -1000 = "lld",
    },
  staticLlvmEnv =
    llvmEnv
    & {
      _isStatic = true,
      _isLlvm = true,

      CFLAGS = constants.staticFlags @ llvmEnv.CFLAGS,
      CXXFLAGS = constants.staticFlags @ llvmEnv.CXXFLAGS,
      LDFLAGS = constants.staticFlags @ llvmEnv.LDFLAGS,
    },
}
