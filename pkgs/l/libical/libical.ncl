{
  lib,
  drvs,
  libical | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/libical/libical/archive/refs/tags/v3.0.18.tar.gz",
      sha256sum = "72b7dc1a5937533aee5a2baefc990983b66b141dd80d43b51f80aced4aae219c"
    },
    biDrvs = [
      drvs.perl,
    ],
    cmakeArgsRecord = {
      "-DICAL_GLIB" = "false",
      "-DSTATIC_ONLY" = "true",
      "-DGOBJECT_INTROSPECTION" = "false",
      "-DICAL_GLIB_VAPI" = "false",
    }
  }
}
