{
  lib,
  drvs,
  _kf,
  kwayland | lib.CmakePackage =
    _kf
    & {
      singleSource = {
        uri = "https://invent.kde.org/plasma/kwayland/-/archive/v6.4.3/kwayland-v6.4.3.tar.gz",
        sha256sum = "fea25936d9e4febc8c9f5ce5ceb867683083a98b50754b479d00e7c6fc0e39be"
      }
    }
}
