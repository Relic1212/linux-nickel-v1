{
  lib,
  libnet | lib.AutomakePackage
    = {
      configureFlags,
      singleSource = {
        uri = "https://github.com/libnet/libnet/releases/download/v1.3/libnet-1.3.tar.gz",
        sha256sum = "ad1e2dd9b500c58ee462acd839d0a0ea9a2b9248a1287840bc601e774fb6b28f",
      },
      separateBuildDir = false,
      configurePhase = [
        # "./autogen.sh",
        "./configure %{std.string.join " " configureFlags} --with-link-layer=linux",
      ]
    }
}
