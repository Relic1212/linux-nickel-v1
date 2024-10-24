let lib = import "../../nickellib/lib.ncl" in
let misc = import "cmake-base.ncl"
in
let _cmakeStage1 | lib.AutotoolsPackage
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
          " --generator=Ninja",
          "--enable-ccache",
          "--no-debugger",
          "--",
          "-G Ninja",
          "-DLLVM_PARALLEL_LINK_JOBS=$(nproc)",
          "-DLLVM_PARALLEL_COMPILE_JOBS=$(nproc)",
          "-DCMAKE_BUILD_TYPE=Release",
          "-DBUILD_SHARED_LIBS:BOOL=OFF",
          "-DBUILD_STATIC_LIBS:BOOL=ON",
          "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=ON",
          "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
          "-DBUILD_TESTING:BOOL=OFF",
        ]
        @ misc.cmakeCmakeArgs,

      buildPhase = [
        "ninja"
      ],
      installPhase = [
        "DESTDIR=${DEST} ninja install"
      ],
      # buildInputs = [
      #   (import "../busybox/busybox-stage-0.ncl"),
      #   (import "../llvm/llvm-stage-0.ncl"),
      #   (import "../musl/musl-stage-0.ncl"),
      #   (import "../gnumake/gnumake-stage-1.ncl"),
      #   (import "../ccache/ccache-bin.ncl"),
      #   (import "../linux-headers/linux-headers-stage-1.ncl"),
      # ]
    }
  )
  in
{
  busyboxStage0,
  llvmStage0,
  muslStage0,
  gnumakeStage1,
  ninjaStage1,
  samuraiStage1,
  ccacheBin,
  linuxHeadersStage1,
  cmakeStage1 =
    _cmakeStage1
    & {
      # extraEnv|priority 1=misc.cmakeBase.extraEnv&{MAKE="ninja"},
      buildInputs =
        lib.biMap [
          busyboxStage0,
          llvmStage0,
          muslStage0, # TODO
          samuraiStage1,
          ccacheBin,
          linuxHeadersStage1,
        ]
    }
}
