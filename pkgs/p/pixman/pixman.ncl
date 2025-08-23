{
  lib,
  _pixman0434 | lib.MesonPackage = {
    name = "pixman",
    singleSource = {
      uri = "https://cairographics.org/releases/pixman-0.43.4.tar.gz",
      sha256sum = "a0624db90180c7ddb79fc7a9151093dc37c646d8c38d3f232f767cf64b85a226",
    }
  },
  _pixman | lib.MesonPackage = {
    singleSource = {
      uri = "https://www.cairographics.org/releases/pixman-0.46.4.tar.gz",
      sha256sum = "d09c44ebc3bd5bee7021c79f922fe8fb2fb57f7320f55e97ff9914d2346a591c"
    }
  },
  pixman = _pixman0434,
  pixman046 = _pixman,
}
