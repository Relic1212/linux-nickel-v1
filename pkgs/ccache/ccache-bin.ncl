let lib = import "../../nickellib/lib.ncl"
in
let ccacheBin|lib.Package={
    name="ccache-bin",
    buildInChroot=false,
    extraFiles=[
        {
            file="ccache",
            sha256sum="6d84a011b3672240339a64099352b630d0358c2bf7cae7d7a54dc1cfe375bd62"
        }
    ],
    installPhase=[

"install -d -m 0755 ${DEST}/usr/bin",
"install -d -m 0755 ${DEST}/usr/lib/ccache",

"install -m0755 /tmp/workdir/files/ccache  ${DEST}/usr/bin",
"chmod +x  ${DEST}/usr/bin",
    ]
}
in 
ccacheBin