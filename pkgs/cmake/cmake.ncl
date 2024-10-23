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
  "-DCMake_BUILD_DEVELOPER_REFERENCE_HTML=OFF"
]
in
{
  cmakeStage1 | lib.AutotoolsPackage
    =
      cmakeBase
      & {
        stage = 1,
        name = "cmake-stage-1",
        extraEnv=std.record.update "CMAKE_BUILD_PARALLEL_LEVEL" "$(nproc)" cmakeBase.extraEnv,
        configureFlags =
          [
            "--prefix=/usr",
            "--bindir=bin",
            "--parallel=$(nproc)",
            "--no-debugger",
            "--",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DBUILD_SHARED_LIBS:BOOL=OFF",
            "-DBUILD_STATIC_LIBS:BOOL=ON",
            "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=ON",
            "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
            "-DBUILD_TESTING:BOOL=OFF",
          ]
          @ cmakeCmakeArgs,
        buildInputs = [
          (import "../busybox/busybox.ncl").busyboxStage0,
          (import "../llvm/llvm-stage-0.ncl"),
          (import "../musl/musl.ncl").muslStage1,
          (import "../gnumake/gnumake.ncl").gnumakeStage1,
          (import "../ccache/ccache-bin.ncl"),
          (import "../linux-headers/linux-headers.ncl").linuxHeadersStage1,

        ]
      }
}
