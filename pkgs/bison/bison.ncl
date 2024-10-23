let lib = import "../../nickellib/lib.ncl"
in
let 
bisonBase|lib.AutotoolsPackage={
    name|default="bison",
    sourceInputs=[
        {
            src={ uri="https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz", sha256sum="9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2" }
        }
    ],

}
in 
{
    bisonStage1=bisonBase&{
        name="bison-stage-1",
        stage=1,
        buildInputs=[
   (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-1.ncl"),
        (import "../gnumake/gnumake.ncl").gnumakeStage1,
        (import "../ccache/ccache-bin.ncl"),
        (import "../m4/m4.ncl").m4Stage1,
        (import "../busybox/busybox-stage-0.ncl"),
        ],
    }
}