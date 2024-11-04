{
  lib,
  sysklogd | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://github.com/troglobit/sysklogd/releases/download/v2.6.2/sysklogd-2.6.2.tar.gz",
        sha256sum = "40a3bb593d7507e49a4379f48ae8a9bc4b68dcc583efcdbf3b9056128442c92a",
      }
    }
}
