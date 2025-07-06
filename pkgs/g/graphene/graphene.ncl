{
  lib,
  pcre2,
  libffi,
  zlibNg,
  glib,

  graphene | lib.MesonPackage = {
    singleSource = {
      uri = "https://download.gnome.org/sources//graphene/1.10/graphene-1.10.8.tar.xz",
      sha256sum = "a37bb0e78a419dcbeaa9c7027bcff52f5ec2367c25ec859da31dfde2928f279a"
    },
    biDrvs =
      lib.biMap [
        pcre2,
        libffi,
        zlibNg,
        glib,
      ],
  }
}
