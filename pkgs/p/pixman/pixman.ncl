{
  lib,
  pixman | lib.MesonPackage
    = {
      name = "pixman",
      singleSource = {
        uri = "https://cairographics.org/releases/pixman-0.43.4.tar.gz",
        sha256sum = "a0624db90180c7ddb79fc7a9151093dc37c646d8c38d3f232f767cf64b85a226",
      }
    }
}
