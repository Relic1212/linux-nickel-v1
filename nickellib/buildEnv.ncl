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

    CFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CFLAGS,
          STATIC_CFLAGS,
          LLVM_CFLAGS,
          STAGE_CFLAGS,
          EXTRA_CFLAGS
        ],
    CPPFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CPPFLAGS,
          STATIC_CPPFLAGS,
          LLVM_CPPFLAGS,
          STAGE_CPPFLAGS,
          EXTRA_CPPFLAGS
        ],
    CXXFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CXXFLAGS,
          STATIC_CXXFLAGS,
          LLVM_CXXFLAGS,
          STAGE_CXXFLAGS,
          EXTRA_CXXFLAGS
        ],
    LDFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_LDFLAGS,
          STATIC_LDFLAGS,
          LLVM_LDFLAGS,
          STAGE_LDFLAGS,
          EXTRA_LDFLAGS
        ],

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

    STAGE_CFLAGS | nullOrArray | default = null,
    STAGE_CPPFLAGS | nullOrArray | default = null,
    STAGE_CXXFLAGS | nullOrArray | default = null,
    STAGE_LDFLAGS | nullOrArray | default = null,

    EXTRA_CFLAGS | nullOrArray | default = null,
    EXTRA_CPPFLAGS | nullOrArray | default = null,
    EXTRA_CXXFLAGS | nullOrArray | default = null,
    EXTRA_LDFLAGS | nullOrArray | default = null,

    SOURCE_DATE_EPOCH | String | default = "\"1302044400\"",
  },
}
