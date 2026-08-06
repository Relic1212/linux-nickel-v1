{
  lib,
  drvs,
  gn | lib.Package = {
    singleSource = {
      uri = "https://gn.googlesource.com/gn.git",
      sha256sum = "64d35867ca0a1088f13de8f4ccaf1a5687d7f1ce"
    },
    separateBuildDir = false,
    configurePhase = [
      "python build/gen.py"
    ],
    buildPhase = [
      "ninja -C out"
    ],
    installPhase = [
      # "install -Dm0755 ${DEST}/usr/bin",
      "install -Dm0755 out/gn ${DEST}/usr/bin/gn",
    ],
    muslProvider,
    biDrvs = [
      drvs.samurai,
      drvs.pythonFull,
      muslProvider,
      drvs.git,
      drvs.llvm,
      drvs.ccacheBin,
    ]
  },
  gn2435 | lib.Package =
    gn
    & {
      singleSource = {
        sha256sum | priority 1 = "1d86777e7f2562a86ecea77d1809ac4f82bb5bfe"
      }
    },
  gnOld | lib.Package =
    gn
    & {
      # https://gn.googlesource.com/gn/+/c0744edfd85862677d625f0fdadda9edc95eed35
      singleSource.sha256sum | priority 1 = "c0744edfd85862677d625f0fdadda9edc95eed35",

      preConfigurePhase =
        [
          m%"sed -i 's@-stdlib=libstdc++@-stdlib=libc++@g' ${SRC}/build/gen.py"%,
          m%"sed -i 's@-lgcc_s@-lunwind@g' ${SRC}/build/gen.py"%,
        ]
        @ (
          std.array.map
            (fun s => "sed -i 's|stat64|stat|g' ${SRC}/%{s}"
            )
            [
              "base/files/file.h",
              "base/files/file_posix.cc",
              "base/files/file_util_posix.cc",
            ]
        ),
      configurePhase | priority 1 = [
        "python build/gen.py --no-sysroot",
      ],
      muslProvider,

      biDrvs | priority 1 = [
        drvs.samurai,
        drvs.python2,
        muslProvider,
        drvs.git,
        drvs.llvm,
        drvs.ccacheBin,
      ]
    }
}
