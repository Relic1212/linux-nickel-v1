{
  lib,
  drvs,
  angle | lib.Package = {
    singleSource = {
      uri = "https://github.com/google/angle/archive/69ac0775b7c5feac2c3a63980695af0dcb0db336.tar.gz",
      sha256sum = "b09fd9c8f3d915c76b715be68ec98596473b474bc4c97e1142ca25c87fc21f32"
    },
    sourceInputs =
      [
        {
          src = singleSource
        },
        # {
        #     src = {
        #         uri = "https://chromium.googlesource.com/chromium/src/build.git",
        #         fetchMethod = "git",
        #         sha256sum = "43136e36e26e16c0b83fc491e5375d2207fd7a34"
        #     },
        #     dest = "build"
        # },
        # {
        #     src = {
        #         uri = "https://chromium.googlesource.com/chromium/src/testing.git",
        #         fetchMethod = "git",
        #         sha256sum = "a64382356dba187a672ef52961c9a0e00a0b6dc1"
        #     },
        #     dest = "testing"
        # },
      ]
      @ (import "submodules.json")
    #
    ,separateBuildDir = false,
    unpackPhase =
      [
        "tar xf /tmp/workdir/packed/%{singleSource.sha256sum}/*.tar.gz -C /tmp/workdir/src --strip-components=1",
        "cp -r /tmp/workdir/packed/*/* /tmp/workdir/src/",
      ]
      @ (
        std.array.map
          (fun src =>
            "mkdir -p /tmp/workdir/src/%{src.dest}\n"
            ++ "cp -r /tmp/workdir/packed/%{src.src.sha256sum}/%{src.dest}/* /tmp/workdir/src/%{src.dest}/"
          )
          (std.array.drop_first sourceInputs)
      ),
    configurePhase = [
      #   "(cd bin && ln -s /usr/bin/gn gn)",
      "touch build/config/gclient_args.gni",
      m%"gn gen out/Release --args='use_sysroot=false'"%,
    ],
    buildPhase = [
      "ninja -C out/Release"
    ],
    installPhase = [
      "install -dm0755 ${DEST}/usr/lib",
      "install -dm0755 ${DEST}/usr/include/skia",
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
  }
}
