{
  lib,
  drvs,

  ffmpeg | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.ffmpeg.org/releases/ffmpeg-8.0.1.tar.xz",
      sha256sum = "05ee0b03119b45c0bdb4df654b96802e909e0a752f72e4fe3794f487229e5a41"
    },
    extraEnv = {
      HOSTCC = ["clang", "-static"],
      HCFLAGS = ["-static"],
      HLDFLAGS = ["-static"],
    },
    configureFlags = [
      "--prefix=/usr",
      "--enable-static",
      "--disable-shared",
      "--host-cc='clang -static'",
      "--host-ld='clang -static'",
      "--ld=clang",
      "--cc=clang",
      "--cxx=clang++",
      "--enable-ffplay",

      # from Alpine
      "--enable-gpl",
      "--enable-libdrm",
      "--enable-libfontconfig",
      "--enable-libfreetype",
      "--enable-libfribidi",
      "--enable-openssl",
      "--enable-version3",
      # "--enable-opengl",
    ],

    llvmProvider = drvs.llvmFull,
    biDrvs = [
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
      drvs.nasm,
      drvs.fribidi,
      drvs.openssl,
      drvs.pkgconf,
      drvs.bison,
      drvs.m4,
    ]
  }
}
& {
  lib,
  drvs,
  nasm | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz",
      sha256sum = "1412a1c760bbd05db026b6c0d1657affd6631cd0a63cddb6f73cc6d4aa616148"
    }
  }
}
