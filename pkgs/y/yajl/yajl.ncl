{
  lib,

  yajl | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/lloyd/yajl/archive/6bc5219389fd2752631682b0a8368e6d8218a8c5.zip",
      sha256sum = "ffa9b4c85f97aec59db1060c2414d90ede72fa9e96ee70dac84e0b7a221ee649"
    }
  }
}
