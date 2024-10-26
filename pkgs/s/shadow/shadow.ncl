{
    lib,
    pkgs,
    shadow|lib.AutotoolsPackage={
        name="shadow",
        singleSource={
            uri="https://github.com/shadow-maint/shadow/releases/download/4.16.0/shadow-4.16.0.tar.gz",
            sha256sum="1744f339e07a2b41056347ddd612839762ff565d7e9494fb049428002fa2e7e0",
        },
        preConfigurePhase=[
            m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.am"%,
m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/Makefile.in"%,
m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.am"%,
m%"sed -i 's/\/sbin/\/bin/g' ${SRC}/src/Makefile.in"%,
        ],
        biPkgs=[
            pkgs.pkgconf,
            pkgs.libmd,
            pkgs.libbsd,
        ]
    }
}