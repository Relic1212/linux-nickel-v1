{
  lib,
  drvs,
  libqtxdg | lib.LxqtPackage = {
    singleSource = {
      uri = "https://github.com/lxqt/libqtxdg/archive/refs/tags/4.3.0.tar.gz",
      sha256sum = "2a19343cffaa869d5001ef8087781beedb25b3f2ebe29f202728a9dc86aaacc8",
    },
    # patches = [
    #     {
    #         sha256sum = "6cfeda8f67dc3647fe1be5a620abc36b6d18c68c10a2ccba46f5c0a39bc9dfed",
    #         file="liblxqt.patch",
    #     },
    # ],
    buildEnv = {
      EXTRA_LDFLAGS = [
        "-Wl,--allow-multiple-definition",
      ],
    },
    preConfigurePhase = [
      "sed -i 's|QIconCacheGtkReader|libqtxdg__QIconCacheGtkReader|g' ${SRC}/src/xdgiconloader/xdgiconloader_p.h",
      "sed -i 's|QIconCacheGtkReader|libqtxdg__QIconCacheGtkReader|g' ${SRC}/src/xdgiconloader/xdgiconloader.cpp",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/src/xdgiconloader/CMakeLists.txt",
      "sed -i 's|MODULE|STATIC|g' ${SRC}/src/xdgiconloader/plugin/CMakeLists.txt",
      "sed -i 's|SHARED|STATIC|g' ${SRC}/src/qtxdg/CMakeLists.txt",

      # "sed -i 's|QPixmap PPixmapEntry|QPixmap Plibqtxdg__PixmapEntry|g' ${SRC}/src/xdgiconloader/xdgiconloader.cpp",
      # "sed -i 's|QPixmap ScalableEntry|QPixmap libqtxdg__ScalableEntry|g' ${SRC}/src/xdgiconloader/xdgiconloader.cpp",
      # m%"sed -i "@include <private\/qhexstring_p.h>@include <private\/qhexstring_p.h>\nnamespace LibQtXdg \{@g" ${SRC}/src/xdgiconloader/xdgiconloader.cpp"%,

      # m%"echo '}' >> ${SRC}/src/xdgiconloader/xdgiconloader.cpp"%,
    ],

    postInstallPhase =
      std.array.map
        (fun s =>
          " llvm-objcopy  --weaken-symbol %{s} ${DEST}/usr/lib/libQt6XdgIconLoader.a "
        )
        [
          "_ZN13ScalableEntry6pixmapERK5QSizeN5QIcon4ModeENS3_5StateEd",
          "_ZN13ScalableEntryD0Ev",
          "_ZN13ScalableEntryD2Ev",
          "_ZTI13ScalableEntry",
          "_ZTS13ScalableEntry",
          "_ZTV13ScalableEntry",
          "_ZN11PixmapEntry6pixmapERK5QSizeN5QIcon4ModeENS3_5StateEd",
          "_ZN11PixmapEntryD0Ev",
          "_ZN11PixmapEntryD2Ev",
          "_ZTI11PixmapEntry",
          "_ZTS11PixmapEntry",
          "_ZTV11PixmapEntry",
        ],
    biDrvs = [
      drvs.lxqtBuildTools,
    ],
  }
}
