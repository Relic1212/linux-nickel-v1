{
  lib,
  pcre2 | lib.AutotoolsPackage
    = {
      name = "pcre2",
      singleSource = {
        uri = "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-10.44/pcre2-10.44.tar.gz",
        sha256sum = "86b9cb0aa3bcb7994faa88018292bc704cdbb708e785f7c74352ff6ea7d3175b",
      }
    }
}
