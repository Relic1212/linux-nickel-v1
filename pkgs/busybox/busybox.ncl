let 
lib=import "../../nickellib/lib.ncl"
in 
let 
bbase|lib.MakePackage={
    name="busybox",
    sourceInputs=[
        {
            src={
                uri="https://busybox.net/downloads/busybox-1.37.0.tar.bz2",
                sha256sum="1",
            }
        },
        {
            dest="patches",
            src
        }
    ],
    buildDir="/tmp/workdir/src",
}
in {

}