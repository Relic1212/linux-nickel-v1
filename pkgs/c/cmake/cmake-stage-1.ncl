let misc = import "cmake-base.ncl" in

{

  drvs,
  lib,
  cmakeStage1
    | lib.AutotoolsPackage
    =
      # misc.cmakeBase
      # &
      {
        stage = 1,
        # extraEnv = std.record.update "CMAKE_BUILD_PARALLEL_LEVEL" "$(nproc)" lib.AutotoolsPackage.extraEnv,
        extraEnv = lib.AutotoolsPackage.extraEnv & { "CMAKE_BUILD_PARALLEL_LEVEL" | force = "$(nproc)" },

        buildEnv = {
          _isLlvm = false,
          # STAGE_CFLAGS= [
          #   "-I/include"
          # ],
          # STAGE_CPPFLAGS=[
          #   "-I/include",
          # ],
          CXX = [
            "x86_64-linux-musl-g++",
            "--verbose",
            #  "--sysroot=/"
          ],

          #  this would not be needed if we installed the kernel headers in bootstrap-stage-0
          STAGE_CXXFLAGS = [
            "-I/usr/include",
            #"-idirafter/include"
          ],
        },
        #  extraEnv={
        #     "CPLUS_INCLUDE_PATH"="/include/c++/9.4.0:/include",

        #  },

        configureFlags = (
          [
            "--prefix=/usr",
            "--bindir=bin",
            "--parallel=$(nproc)",
            " --generator=Ninja",
            "--no-debugger",
            "--",
            "-G Ninja",
            # "-DLLVM_PARALLEL_LINK_JOBS=$(nproc)",
            # "-DLLVM_PARALLEL_COMPILE_JOBS=$(nproc)",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DBUILD_SHARED_LIBS:BOOL=OFF",
            "-DBUILD_STATIC_LIBS:BOOL=ON",
            "-DCMAKE_LINK_SEARCH_START_STATIC:BOOL=ON",
            "-DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON",
            "-DBUILD_TESTING:BOOL=OFF",
          ]
          @ misc.cmakeCmakeArgs
        ),

        buildPhase = [
          "ninja"
        ],
        installPhase = [
          "DESTDIR=${DEST} ninja install"
        ],
        singleSource = misc.cmakeSingleSource,

        biDrvs = [
          drvs.busyboxBootstrapStage0,
          drvs.bootstrapStage0,
          drvs.bootstrapSymlinks,
          drvs.muslStage1,
          drvs.samuraiStage1,
          drvs.ccacheBin,
          drvs.linuxHeadersStage1,
        ]
      }
}
