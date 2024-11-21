{
  lib,
  drvs,
  dejavuFonts | lib.MakePackage
    = {
      singleSource = {
        uri = "https://github.com/dejavu-fonts/dejavu-fonts/archive/refs/tags/version_2_37.tar.gz",
        sha256sum = "c4d10a1b665db893adc0c0aaee7ecd81b2b47c877d5cea0b40216707cbf327e4"
      }
    }
}
& {
  lib,
  drvs,
  fontforge | lib.CmakePackage
    = {
      generator = "Ninja",
      singleSource = {
        uri = "https://github.com/fontforge/fontforge/archive/refs/tags/20230101.tar.gz",
        sha256sum = "ab0c4be41be15ce46a1be1482430d8e15201846269de89df67db32c7de4343f1"
      },
      biDrvs = [
        drvs.freetype,
        drvs.zlibNg,
        drvs.gperf,
        drvs.expat,
        drvs.fontconfig,
        drvs.gettext,
        drvs.glib,
        drvs.pcre2,
        drvs.libffi,
        drvs.libxml2,
      ],
    }
}
