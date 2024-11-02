{
  lib,
  bkeymaps | lib.MakePackage
    = {
      singleSource = {
        uri = "https://dev.alpinelinux.org/bkeymaps/bkeymaps-1.13.tar.gz",
        sha256sum = "59d41ddb0c7a92d8ac155a82ed2875b7880c8957ea4308afa633c8b81e5b8887",
      },
      # buildDir = "${SRC}",
      separateBuildDir = false,
    }
}
