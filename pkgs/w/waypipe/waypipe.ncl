{
  lib,
  drvs,
  waypipe | lib.CargoPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v0.11.2/waypipe-v0.11.2.tar.bz2",
      sha256sum = "be2d59871a9dc67a78f800f08cfba08bb22d660a97a2def24a4df9b8da6196a7",
    },
    crates = lib.functions.filterCrates (import "waypipe-crates.json"),
    # extraEnv = {
    #     RUST_BACKTRACE="full" ,
    # },

    extraCargoFlags = [
      "--no-default-features",
      "--features=video,lz4,zstd,gbmfallback,test_proto",
      # "video", "dmabuf", "lz4", "zstd", "gbmfallback", "test_proto"
    ],

    buildEnv = {
      EXTRA_LDFLAGS = [
        "-lc++",
      ],
    },

    configurePhase =
      let args = [
        "--prefix=/usr",
        "--buildtype=release",
        "--bindir=bin",
        "--sbindir=bin",
        "--datadir=share",
        "--libdir=lib",
        "--libexecdir=libexec",
        "--includedir=include",
        "--mandir=share/man",
        "--infodir=share/info",
        "--sysconfdir=/etc",
        "--localstatedir=/var",
        "--sharedstatedir=/com",
        "--wrap-mode=nodownload",
        "--prefer-static",
        "-Ddefault_library=static",
        "-Dwerror=false",
        "-Dbuild_c=true",
        "-Dman-pages=enabled",
        # "-Dwith_gbm=enabled",
        # "-Dwith_dmabuf=enabled",
      ]
      in
      [
        "cd ${BUILDDIR}",
        m%"meson setup %{std.string.join lib.constants.buildFlagSep args} . ${SRC}
      "%,
      ],
    buildPhase = [
      "meson compile",
    ],
    installPhase = [
      "meson install --destdir ${DEST}",
    ],
    llvmProvider = drvs.llvmFull,
    biDrvs = [
      drvs.shaderc,
      drvs.zstd,
      drvs.lz4,
      drvs.ffmpeg,
      drvs.bindgen,
      drvs.fontconfig,
      drvs.freetype,
      drvs.zlibNg,
      drvs.gperf,
      drvs.pixman,
      drvs.wayland,
      drvs.waylandProtocols,
      drvs.libffi,
      drvs.libxkbcommon,
      drvs.expat,
      drvs.linuxHeaders,
      drvs.libdrm,
      drvs.libpciaccess,
      drvs.libelf,
      drvs.mesa2,
      drvs.fribidi,
      drvs.openssl,
      drvs.vulkanHeaders,
      drvs.meson,
      drvs.pythonFull,
      drvs.musl & { priority = 1 },
      drvs.samurai,
      drvs.scdoc,
    ],
  }
}
