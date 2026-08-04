{
  lib,
  drvs,
  debianutils | lib.AutomakePackage = {
    singleSource = {
      uri = "http://deb.debian.org/debian/pool/main/d/debianutils/debianutils_5.23.2.tar.xz",
      sha256sum = "79e524b7526dba2ec5c409d0ee52ebec135815cf5b2907375d444122e0594b69",
    },
    extraConfigureFlags = [
      "--disable-nls",
      "--disable-man",
      "--disable-docs",
      "--disable-po4a-translate",
      "--without-po4a-translate",
    ],
    preConfigurePhase = [
      #   "rm -rf ${SRC}/po4a",
      #   "mkdir ${SRC}/po4a",
      "sed -i 's|SUBDIRS = po4a|SUBDIRS =|g' ${SRC}/Makefile.am",
    ],
  }
}
