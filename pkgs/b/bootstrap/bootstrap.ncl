{
  lib,

  _tinycc | lib.AutotoolsPackage
    = {
      singleSource = {
        uri = "https://repo.or.cz/tinycc.git/snapshot/a21b5f1fd7eda4f8b23ed5c5cc3f6ead748401db.tar.gz",
        sha256sum = "fa56d5809be8063b5ee750bf402d3cd24e0337e37237797e610276486abc922f",
      },

      preConfigurePhase = [
        "export CC=\"${CC} -static\""
      ],
    },
  tinycc = _tinycc,
}
& (
  import "bootstrap-musl-cross-make.ncl"
)
