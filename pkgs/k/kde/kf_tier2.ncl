{
  lib,
  drvs,
  _kfBase,
  _kCommon,
  kftier2 | lib.QtPackage =
    _kfBase
    & {
      sourceInputs = _kCommon.tier2sources,
      separateBuildDir = false,
      preConfigurePhase = [

        # kauth
        "sed -i 's@ MODULE @ @g' ${SRC}/kauth/src/CMakeLists.txt",
        # -kauth

        # kpackage
        m%"sed -i 's@NOT BUILD_SHARED_LIBS@FALSE@g' ${SRC}/kpackage/src/kpackage/CMakeLists.txt"%, # it really is kpackage/src/kpackage
        # -kpackage
      ],
      cmakeExtraArgsRecord,
      cmakeArgs,
      configurePhase = [
        "for d in $(ls); do ",
        "echo \"building $d\"",
        "cd $d",
        "cmake -B build -S . %{std.string.join " " cmakeArgs }",
        "cmake --build build",
        "DESTDIR=${DEST} cmake --install build",
        "cd ..",
        "done",
      ],
      buildPhase = [],
      installPhase = [],
      biDrvs | priority 1 =
        _kfBase.biDrvs
        @ [
          drvs.kftier1,
          drvs.libcanberra,
          drvs.libogg,
          drvs.libtool,
          drvs.libvorbis,
        ]
    },
}
