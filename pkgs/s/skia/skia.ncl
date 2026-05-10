{
  lib,
  drvs,
  skia | lib.Package = {
    singleSource = {
      uri = "https://github.com/google/skia/archive/ee20d565acb08dece4a32e3f209cdd41119015ca.tar.gz",
      sha256sum = "8ff4c6b0a592ee8013d697c074d3c1989b581e9e22152d2839a12db1726bfce2"
    },

    sourceInputs =
      [
        {
          src = singleSource
        }
      ]
      @ (
        import "deps.ncl"
      ),

    separateBuildDir = false,
    configurePhase = [
      "(cd bin && ln -s /usr/bin/gn gn)",
      m%"gn gen out/Static --args='is_official_build=true cc="clang" cxx="clang++" skia_use_gl=false'"%,
    ],
    buildPhase = [
      "ninja -C out/Static"
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -dm0755 ${DEST}/usr/include/skia",
      "for f in $(find ./out -name '*.a'); do install -m0755 ${f} ${DEST}/usr/lib;done",
      "for f in $(find ./include -name '*.h' | grep -v third_party); do install -m0755 ${f} ${DEST}/usr/include/skia; done",
      # "install -Dm0755 out/gn ${DEST}/usr/bin/gn",
    ],
    muslProvider,
    biDrvs = [
      drvs.samurai,
      drvs.pythonFull,
      muslProvider,
      drvs.git,
      drvs.llvm,
      drvs.gn,
      drvs.ccacheBin,
      drvs.zlibNg,
      drvs.libicu,
      drvs.harfbuzz,
      drvs.freetype,
      drvs.cairo,
      drvs.pixman,
      drvs.fontconfig,
      drvs.libpng,
      drvs.expat,
      drvs.libjpegTurboStatic,
      drvs.libwebp,
    ]
  },
  skiaPc | lib.Package = {
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib/pkgconfig",
      "echo '%{import "skia.pc" as 'Text}' > ${DEST}/usr/lib/pkgconfig/skia.pc",
    ]
  }
}
