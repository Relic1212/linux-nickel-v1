let
#lib=import "../../nickellib/lib.ncl"
lib = import "../../nickellib/lib.ncl"
in
let pkgs = {
  muslStage0 = import "../musl/musl-stage-0.ncl",
}
in
let binutilsBase | lib.AutotoolsPackage
  = {
    stage | default = lib.AutotoolsPackage.stage,
    name |priority -1= "binutils",
    isLlvm=false,
    sourceInputs = [
      {
        src = {
          uri = "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.xz",
          sha256sum = "b53606f443ac8f01d1d5fc9c39497f2af322d99e14cea5c0b4b124d630379365",
        }
      }
    ],
    configureFlags = (
      lib.AutotoolsPackage.configureFlags
      @ [
        "--disable-gdb",
        "--disable-gprofng",
        "--disable-multilib",
        "--disable-nls",
        "--disable-werror",
        "--enable-host-shared=no",
        "--disable-host-shared",
        "--with-static-standard-libraries",
      ]
      @ (
        if (stage == 0) then
          [
            "--with-sysroot=/tmp/workdir/sysroot/"
          ]
        else
          []
      )
    ),
    # makeArgs=[
    #     "MAKEINFO=\"$(which true)\""
    # ],
  }
  in
{
  binutilsStage0 = (binutilsBase & { stage = 0, name = "binutils-stage-0", buildInputs = [pkgs.muslStage0, ] }),
}
