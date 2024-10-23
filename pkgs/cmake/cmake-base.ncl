let lib = import "../../nickellib/lib.ncl"
in
let cmakeBase | lib.Package
  = {
    name | priority -10 = "cmake",
    sourceInputs = [
      {
        src = {
          uri = "https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3.tar.gz",
          sha256sum = "6d5de15b6715091df7f5441007425264bdd477809f80333fdf95f846aaff88e4",
        },
      },
    ],
  }
  in
let cmakeCmakeArgs = [
  "-DCMAKE_USE_OPENSSL=OFF",
  "-DBUILD_CursesDialog=OFF",
  "-DBUILD_QtDialog=OFF",
  "-DBUILD_CURL_EXE=OFF",
  "-DCMake_BUILD_DEVELOPER_REFERENCE_HTML=OFF",
  "-DENABLE_ZSTD:BOOL=OFF",
  "-DENABLE_OPENSSL:BOOL=OFF",
  "-DENABLE_LIBB2:BOOL=OFF",
  "-DENABLE_LZ4:BOOL=OFF",
  "-DENABLE_LZMA:BOOL=OFF",
  "-DENABLE_BZip2:BOOL=OFF",
  "-DENABLE_LIBXML2:BOOL=OFF",
  "-DENABLE_EXPAT:BOOL=OFF",
  "-DENABLE_PCREPOSIX:BOOL=OFF",
  "-DENABLE_LIBGCC:BOOL=OFF",
  "-DENABLE_CNG:BOOL=OFF",
  "-DENABLE_TAR:BOOL=OFF",
  "-DENABLE_CPIO:BOOL=OFF",
  "-DENABLE_CAT:BOOL=OFF",
  "-DENABLE_UNZIP:BOOL=OFF",
  "-DENABLE_XATTR:BOOL=OFF",
  "-DENABLE_ACL:BOOL=OFF",
  "-DENABLE_ICONV:BOOL=OFF",
  "-DCMAKE_ASM_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
  "-DCMAKE_C_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
  "-DCMAKE_CXX_FLAGS_RELEASE:STRING='-O0 -DNDEBUG'",
  "-DENABLE_IPV6:BOOL=OFF",
  "-DBUILD_LIBCURL_DOCS:BOOL=OFF",
  "-DBUILD_MISC_DOCS:BOOL=OFF",
  "-DENABLE_CURL_MANUAL:BOOL=OFF",
  "-DCURL_ENABLE_SSL:BOOL=OFF",
  "-DUSE_LIBIDN2:BOOL=OFF",
  "-DCURL_USE_LIBPSL:BOOL=OFF",
  "-DCURL_USE_LIBSSH2:BOOL=OFF",
  "-DCMake_BUILD_DEVELOPER_REFERENCE_HTML:BOOL=OFF",
]
in
let b = cmakeBase in
let args = cmakeCmakeArgs in
{
  cmakeBase = b,
  cmakeCmakeArgs = args
}
