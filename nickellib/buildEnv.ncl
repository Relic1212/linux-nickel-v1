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
                  "TARGET",
                  "HOST",
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
  NullOrStringOrArray,
  BuildEnv = {
    _isStatic | Bool | default = true,
    _isLlvm | Bool | default = true,
    _stage | Number | optional,
    _isCross = TARGET != HOST,
    TARGET | nullOrString | default = null,
    HOST | nullOrString | default = null,

    CC | NullOrStringOrArray | default = if _isCross then ["clang", "--target=%{TARGET}", "--sysroot=/%{TARGET}"] else if _isLlvm then ["clang"] else null,
    CPP | NullOrStringOrArray | default = if _isCross then ["clang", "--target %{TARGET}", "--sysroot=/%{TARGET}", "-E"] else if _isLlvm then ["clang-cpp"] else null,
    CXX | NullOrStringOrArray | default = if _isCross then ["clang++", "--target=%{TARGET}", "--sysroot=/%{TARGET}"] else if _isLlvm then ["clang++"] else null,
    AR | nullOrString | default = if _isLlvm then "llvm-ar" else null,
    AS | nullOrString | default = if _isLlvm then "llvm-as" else null,

    NM | nullOrString | default = if _isLlvm then "llvm-nm" else null,
    RANLIB | nullOrString | default = if _isLlvm then "llvm-ranlib" else null,
    READELF | nullOrString | default = if _isLlvm then "llvm-readelf" else null,
    OBJDUMP | nullOrString | default = if _isLlvm then "llvm-objdump" else null,
    OBJCOPY | nullOrString | default = if _isLlvm then "llvm-objcopy" else null,
    LD | NullOrStringOrArray | default = if _isCross then ["lld", "--target=%{TARGET}", "--sysroot=/%{TARGET}"] else if _isLlvm then "lld" else null,

    CFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CFLAGS,
          CROSS_CFLAGS,
          STATIC_CFLAGS,
          LLVM_CFLAGS,
          STAGE_CFLAGS,
          EXTRA_CFLAGS
        ],
    CPPFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CPPFLAGS,
          CROSS_CPPFLAGS,
          STATIC_CPPFLAGS,
          LLVM_CPPFLAGS,
          STAGE_CPPFLAGS,
          EXTRA_CPPFLAGS
        ],
    CXXFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_CXXFLAGS,
          CROSS_CXXFLAGS,
          STATIC_CXXFLAGS,
          LLVM_CXXFLAGS,
          STAGE_CXXFLAGS,
          EXTRA_CXXFLAGS
        ],
    LDFLAGS | nullOrArray | default
      =
        functions.flattenNullOrArray [
          BASE_LDFLAGS,
          CROSS_LDFLAGS,
          STATIC_LDFLAGS,
          LLVM_LDFLAGS,
          STAGE_LDFLAGS,
          EXTRA_LDFLAGS
        ],

    # Stage 0 is never cross-compiled, so we can always but stuff in /${TARGET}
    CROSS_CFLAGS | nullOrArray | default
      =
        if (HOST == TARGET) then
          null
        else
          [
            # "-target %{TARGET}",
            # "--sysroot=/%{TARGET}"
          ],
    CROSS_CPPFLAGS | nullOrArray | default
      =
        if (HOST == TARGET) then
          null
        else
          [
            # "-target %{TARGET}",
            # "--sysroot=/%{TARGET}",
          ],
    CROSS_CXXFLAGS | nullOrArray | default
      =
        if (HOST == TARGET) then
          null
        else
          [
            # "-target %{TARGET}",
            # "--sysroot=/%{TARGET}"
          ],
    CROSS_LDFLAGS | nullOrArray | default
      =
        if (HOST == TARGET) then
          null
        else
          [
            # "-target %{TARGET}",
            # "--sysroot=/%{TARGET}"
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
