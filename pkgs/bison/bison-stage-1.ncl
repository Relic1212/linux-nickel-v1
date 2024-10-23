let bisonBase=import "bison-base.ncl" in 
let 
 bisonStage1=bisonBase&{
        name="bison-stage-1",
        stage=1,
        buildInputs=[
   (import "../llvm/llvm-stage-0.ncl"),
        (import "../musl/musl-stage-1.ncl"),
        (import "../gnumake/gnumake-stage-1.ncl"),
        (import "../ccache/ccache-bin.ncl"),
        (import "../m4/m4-stage-1.ncl"),
        (import "../busybox/busybox-stage-0.ncl"),
        ],
    }
in 
{
     muslStage1,gnumakeStage1,ccacheBin,m4Stage1,busyboxStage0,
bisonStage1&{
buildInputs=[
          muslStage1,gnumakeStage1,ccacheBin,m4Stage1,busyboxStage0,

]
}

}