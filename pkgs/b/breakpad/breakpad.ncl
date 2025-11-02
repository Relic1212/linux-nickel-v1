{
  lib,
  drvs,
  breakpad | lib.AutotoolsPackage = {
    singleSource = {
      uri = "https://github.com/google/breakpad/archive/refs/tags/v2024.02.16.tar.gz",
      sha256sum = "b1940cd9231822f1d332d1776456afa8d452e59799cbeef70641885c39547b28",
    }
  }
}
