{
  lib,

  epollShim | lib.CmakePackage = {
    generator = "Ninja",
    singleSource = {
      uri = "https://github.com/jiixyj/epoll-shim/archive/refs/tags/v0.0.20240608.tar.gz",
      sha256sum = "8f5125217e4a0eeb96ab01f9dfd56c38f85ac3e8f26ef2578e538e72e87862cb"
    }
  }
}
