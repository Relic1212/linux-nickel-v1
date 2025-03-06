{
  lib,
  drvs,
  attr | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://download.savannah.nongnu.org/releases/attr/attr-2.5.2.tar.xz",
      sha256sum = "f2e97b0ab7ce293681ab701915766190d607a1dba7fae8a718138150b700a70b"
    },
    patches = [
      {
        file = "0001-gentoo-attr-2.5.2-r1-musl-1.2.5.patch",
        sha256sum = "f079b544f17bb61576c82760effc4fbad1beda8f9744fc92e9f0f512ccfa55c6"
      }
    ]
  }
}
