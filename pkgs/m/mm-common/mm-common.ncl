{
  lib,
  drvs,
  mmCommon | lib.MesonPackage = {
    singleSource = {
      uri = "https://gitlab.gnome.org/GNOME/mm-common/-/archive/1.0.8/mm-common-1.0.8.tar.bz2",
      sha256sum = "354e7554f83f47b9b6b6ba20b779ba364489156de2758f5cd98e6a2f93fdb93f",
    },
    sourceInputs = [
      { src = singleSource },
      {
        src = {
          uri = "https://gcc.gnu.org/onlinedocs/gcc-13.5.0/libstdc++/api/libstdc++.tag",
          sha256sum = "64da57d97f272a4884ce26347010017133e0d52e5d5a159ae332872e8cae04d1",
        },
        dest = "doctags",
      },
    ],
    extraMesonArgs = [
      "-Duse-network=false",
    ],
  }
}
