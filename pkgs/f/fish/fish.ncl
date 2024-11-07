{
  lib,
  drvs,
  fish | lib.CmakePackage
    = {
      singleSource = {
        uri = "https://github.com/fish-shell/fish-shell/releases/download/3.7.0/fish-3.7.0.tar.xz",
        sha256sum = "df1b7378b714f0690b285ed9e4e58afe270ac98dbc9ca5839589c1afcca33ab1",
      },
      generator = "Ninja",
      biDrvs = [
        drvs.ncurses,
        drvs.readline,
        drvs.pcre2cmake,
        drvs.gettext,
      ],
      preConfigurePhase = [
        m%"
            sed -i 's@message(FATAL_ERROR "Fish does not support static linking")@@g' ${SRC}/CMakeLists.txt
            "%
      ],
      cmakeArgsRecord = {
        "-DFISH_USE_SYSTEM_PCRE2" = true,
        # "-DSYS_PCRE2_LIB:PATH" = "/usr/lib/libpcre2-8.a",
      }
    },
  pcre2,
  pcre2cmake | lib.CmakePackage
    = {

      sourceInputs = pcre2.sourceInputs,
      generator = "Ninja",
      cmakeArgsRecord = {
        "-DPCRE2_BUILD_PCRE2_32" = true,
        "-DPCRE2_BUILD_PCRE2_16" = true,
        "-DPCRE2_BUILD_PCRE2_8" = true,
      }
    }
}
