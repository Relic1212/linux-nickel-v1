let lib = import "../../nickellib/lib.ncl" in
let misc = import "cmake-base.ncl"
in
let cmakeStage1 | lib.AutotoolsPackage
  = (
    misc.cmakeBase
    & {
      stage = 1,
      name = "cmake-stage-1",
      extraEnv = std.record.update "CMAKE_BUILD_PARALLEL_LEVEL" "$(nproc)" misc.cmakeBase.extraEnv,
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
        @ misc.cmakeCmakeArgs,
      buildInputs = [
        (import "../busybox/busybox-stage-0.ncl"),
        (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-0.ncl"),
        (import "../gnumake/gnumake-stage-1.ncl"),
        (import "../ccache/ccache-bin.ncl"),
        (import "../linux-headers/linux-headers-stage-1.ncl"),
      ]
    }
  )
  in
cmakeStage1
