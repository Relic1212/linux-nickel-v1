{
  lib,
  drvs,
  waypipe | lib.CargoPackage = {
    singleSource = {
      uri = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/archive/v0.11.0/waypipe-v0.11.0.tar.bz2",
      sha256sum = "e75e4bb5471e6f413aae1e00b0abddf02ec9f1f56db31d4c50535436c4e7282d",
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

    configurePhase = [
      "cd ${BUILDDIR}",
      m%"meson setup --prefix=/usr \
        --buildtype=release \
        --bindir=bin \
        --sbindir=bin \
        --datadir=share \
        --libdir=lib \
        --libexecdir=libexec \
        --includedir=include \
        --mandir=share/man \
        --infodir=share/info \
        --sysconfdir=/etc \
        --localstatedir=/var \
        --sharedstatedir=/com \
        --wrap-mode=nodownload \
        --prefer-static \
        -Dbuild_c=true \
        -Dwerror=false \
        -Ddefault_library=static . ${SRC}
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
    ],
  }
}
