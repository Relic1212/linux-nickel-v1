{
    lib,
    drvs,

    newt|lib.AutotoolsPackage ={
        singleSource={
            uri="https://releases.pagure.org/newt/newt-0.52.24.tar.gz",
            sha256sum="5ded7e221f85f642521c49b1826c8de19845aa372baf5d630a51774b544fbdbb",
        },
        separateBuildDir=false,
        biDrvs=[
            drvs.slang,
            drvs.linuxHeaders,
            drvs.popt,
        ],
        preConfigurePhase=[
            m%"
            sed -i 's@-Wl,--version-script,newt.0.52.ver -Wl,-soname,$(LIBNEWTSONAME)@@g' \
                ${SRC}/Makefile.in

            sed -i 's@-shared@@g' \
                ${SRC}/Makefile.in
            
            "%
        ],
        makeTargets=[
            "libnewt.a",
        ],
        installPhase=[
            "install -d -m0755 ${DEST}/usr/lib",
            "install -m0755 libnewt.a ${DEST}/usr/lib",
            "install -d -m0755 ${DEST}/usr/include",

            "install -d -m0755 ${DEST}/usr/lib/pkgconfig",
            "install -m0755 libnewt.pc ${DEST}/usr/lib/pkgconfig",

            "install -m 644 newt.h ${DEST}/usr/include",

        ]
    }
}