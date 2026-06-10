{
  lib,
  drvs,
  muslLocales | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      # uri = "https://git.adelielinux.org/adelie/musl-locales/-/archive/f6f3cf5fc1ebc1e220c74a4e73c4586d698b4c00/musl-locales-f6f3cf5fc1ebc1e220c74a4e73c4586d698b4c00.tar.bz2",
      uri = "https://gitlab.com/rilian-la-te/musl-locales/-/archive/f6f3cf5fc1ebc1e220c74a4e73c4586d698b4c00/musl-locales-f6f3cf5fc1ebc1e220c74a4e73c4586d698b4c00.tar.bz2",
      sha256sum = "b70ea2e29accfe8fcdf06a080f99104991451a7c54abd50eabeda93fe7981741",
    },
    biDrvs = [
      drvs.gettext,
    ],
  }
}
