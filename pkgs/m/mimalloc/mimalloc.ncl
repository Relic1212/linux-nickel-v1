{
  lib,
  drvs,
  mimalloc | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.0.10.tar.gz",
      # sha256sum = "ee5556a31060f2289497f00126e90bf871e90933f98e21ea13dca3578e9ccfb5",
      uri = "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.7.0.tar.gz",
      sha256sum = "1b8653b9ff9b841a97f2c50fd996e89e1a0cb712c3c5b0980ef16a027eb7acf8",
    },
    # sourceInputs = [
    #     { src = singleSource},
    #     {src ={
    #         uri = "https://raw.githubusercontent.com/tweag/rust-alpine-mimalloc/b26002b49d466a295ea8b50828cb7520a71a872a/mimalloc.diff",
    #         sha256sum = "60cd41a09718f1f0367ba7cecb73b12af267971e98e0afcf02cc526ba2867fb2",
    #     }},
    # ],
    cmakeExtraArgsRecord = {
      "-DMI_BUILD_SHARED" = false,
      # "-DMI_USE_CXX" = true,
      "-DMI_LIBC_MUSL" = true,
      "-DMI_SKIP_COLLECT_ON_EXIT" = true,
    },
    preConfigurePhase = [
      # "(cd ${SRC} && patch -p1 < mimalloc.diff)",
      # m%"sed -i 's|set_property(TARGET mimalloc-static PROPERTY POSITION_INDEPENDENT_CODE ON)||g' ${SRC}/CMakeLists.txt"%,
      # m%"sed -i 's@#elif (defined(__GNUC__) || defined(__clang__))@#elif 0@g' ${SRC}/src/alloc-override.c"%,
    ],

    postInstallPhase = [
      # "cp build/mimalloc.o .",
      # "cp build/mimalloc.o .",
      m%"
      {
          echo "CREATE libc.a"
          echo "ADDLIB /usr/lib/libc.a"
          echo "DELETE aligned_alloc.lo"
          echo "DELETE calloc.lo"
          echo "DELETE donate.lo"
          echo "DELETE free.lo"
          echo "DELETE libc_calloc.lo"
          echo "DELETE lite_malloc.lo"
          echo "DELETE malloc.lo"
          echo "DELETE malloc_usable_size.lo"
          echo "DELETE memalign.lo"
          echo "DELETE posix_memalign.lo"
          echo "DELETE realloc.lo"
          echo "DELETE reallocarray.lo"
          echo "DELETE valloc.lo"
          echo "ADDLIB libmimalloc.a"
          echo "SAVE"
      } | llvm-ar -M
       "%,
      # "cp /usr/lib/libc.a .",
      # "ar d libc.a aligned_alloc.lo calloc.lo donate.lo free.lo libc_calloc.lo lite_malloc.lo malloc_usable_size.lo memalign.lo posix_memalign.lo realloc.lo reallocarray.lo valloc.lo",
      # "ar d libc.a malloc.lo",
      # "ar r libc.a mimalloc.o",
      "objcopy -W dlopen libc.a",
      "objcopy -W dlsym libc.a",
      "objcopy -W dladdr libc.a",
      "objcopy --globalize-symbol stub_dlopen libc.a",
      "objcopy --globalize-symbol stub_dlsym libc.a",
      "objcopy --globalize-symbol stub_dladdr libc.a",
      "install -m0755 libc.a ${DEST}/usr/lib",
    ]
  }
}
