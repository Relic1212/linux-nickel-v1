{
  lib,
  drvs,
  imagemagick | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.2-33.tar.gz",
      sha256sum = "c768ff077cccff1b682aa56653b54247b268752427ca998992b24cc7c597d9e7",
    },

    buildEnv = {
      EXTRA_CPPFLAGS = ["-I/usr/include/libxml2"],
    },
    extraConfigureFlags = [
      "--with-bzlib=yes",
      "--with-fontconfig=yes",
      "--with-freetype=yes",
      "--with-jpeg=yes",
      "--with-jxl=yes",
      "--with-lcms=yes",
      "--with-lzma=yes",
      "--with-pango=yes",
      "--with-png=yes",
      "--with-rsvg=no",
      "--with-tiff=yes",
      "--with-webp=yes",
    ],
    allowDubplicateBuldInputs = true,
    biDrvs = [
      drvs.pkgconfMeson,
    ],
    pDrvs = [
      drvs.bzip2,
      drvs.xz,
      drvs.fontconfig,
      # drvs.freetype,
      drvs.libjxl,
      drvs.libjpegTurbo,
      drvs.lcms,
      # drvs.libpng,
      drvs.libxml2,
      drvs.zstd,
      #   drvs.zlibNg,
      drvs.pango,
      drvs.librsvg,
    ],
  }
}
