{
  lib,
  drvs,

  ffmpeg | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://www.ffmpeg.org/releases/ffmpeg-7.1.tar.xz",
        sha256sum = "40973d44970dbc83ef302b0609f2e74982be2d85916dd2ee7472d30678a7abe6"
      },
      extraEnv = {
        HOSTCC = ["clang", "-static"],
      },
      configureFlags = [
        "--prefix=/usr",
        "--enable-static",
        "--disable-shared",
        "--host-cc=clang",
        "--host-ld=clang",
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
    #"--enable-openssl",
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
        drvs.mesaOpengl,
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
  nasm | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz",
        sha256sum = "1412a1c760bbd05db026b6c0d1657affd6631cd0a63cddb6f73cc6d4aa616148"
      }
    }
}
