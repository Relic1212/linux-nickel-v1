{
  constants,
  functions={
    getFinalBuildEnv = (fun benv=> std.record.filter (fun k v =>(
        # only these values should be exported by the build
        ((std.array.elem k [
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
        ]) && (v!=null))
    ))  benv),
  },
  nullOrString,
  nullOrArray,
  BuildEnv = {
    _isStatic|Bool|optional,
     _isLlvm|Bool|optional,
     _stage|Number|optional,
    CC | nullOrString | default = null,
    CPP | nullOrString | default = null,
    CXX | nullOrString | default = null,
    AR | nullOrString | default = null,
    AS | nullOrString | default = null,

    NM | nullOrString | default = null,
    RANLIB | nullOrString | default = null,
    READELF | nullOrString | default = null,
    OBJDUMP | nullOrString | default = null,
    OBJCOPY | nullOrString | default = null,
    LD | nullOrString | default = null,
    CFLAGS | nullOrArray | default = null,
    CPPFLAGS | nullOrArray | default = null,
    CXXFLAGS | nullOrArray | default = null,
    LDFLAGS | nullOrArray | default = null,
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
      CFLAGS|priority -1 = ["-O2", "-pipe"],
      CXXFLAGS |priority -1= ["-O2", "-pipe"],

      LDFLAGS|priority -1 = ["-fuse-ld=lld", "-stdlib=libc++", "-rtlib=compiler-rt", "-unwindlib=libunwind"],
      LD | priority -1000 = "lld",
    },
  staticLlvmEnv =  llvmEnv&{

    CFLAGS=constants.staticFlags @ llvmEnv.CFLAGS,
    CXXFLAGS=constants.staticFlags @ llvmEnv.CXXFLAGS,
    LDFLAGS=constants.staticFlags @ llvmEnv.LDFLAGS,

  },


}
