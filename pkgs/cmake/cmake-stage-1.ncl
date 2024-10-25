let misc = import "cmake-base.ncl"
in
{

  pkgs,
  lib,
  cmakeStage1
    | lib.AutotoolsPackage
    =
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

        buildInputs =
          lib.biMap [
            pkgs.busyboxStage0,
            pkgs.llvmStage0,
            pkgs.muslStage1,
            pkgs.samuraiStage1,
            pkgs.ccacheBin,
            pkgs.linuxHeadersStage1,
          ]
      }
}
