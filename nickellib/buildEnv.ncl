{
  constants,
  functions,
  nullOrString,
  nullOrArray,
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
  llvmEnv | BuildEnv
    = {
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
      CFLAGS = ["-O2", "-pipe"],
      CXXFLAGS = ["-O2", "-pipe"],

      LDFLAGS = ["-fuse-ld=lld", "-stdlib=libc++", "-rtlib=compiler-rt", "-unwindlib=libunwind"],
      LD | default = "lld",
    },
  staticLlvmEnv = functions.joinMerge staticEnv llvmEnv,
}
