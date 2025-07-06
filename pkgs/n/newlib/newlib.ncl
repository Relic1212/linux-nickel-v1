{
  lib,

  newlib | lib.AutotoolsPackage = {
    separateBuildDir = false,
    singleSource = {
      uri = "http://sourceware.org/pub/newlib/newlib-4.5.0.20241231.tar.gz",
      sha256sum = "33f12605e0054965996c25c1382b3e463b0af91799001f5bb8c0630f2ec8c852",
    }
  }
}
