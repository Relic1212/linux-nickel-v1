{
  lib,
  libpciaccess | lib.MesonPackage = {
    #name = "libpciaccess",
    singleSource = {
      uri = "https://x.org/releases/individual/lib/libpciaccess-0.18.1.tar.xz",
      sha256sum = "4af43444b38adb5545d0ed1c2ce46d9608cc47b31c2387fc5181656765a6fa76",
    }
  }
}
