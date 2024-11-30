{
    lib,
    drvs,
    acpid | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://sourceforge.net/projects/acpid2/files/acpid-2.0.34.tar.xz",
            sha256sum = "2d095c8cfcbc847caec746d62cdc8d0bff1ec1bc72ef7c674c721e04da6ab333"
        },
        biDrvs = [
            drvs.linuxHeaders,
        ],
        preConfigurePhase = [
            "sed -i 's@struct stat64 st@struct stat st@g' ${SRC}/sock.c",
            "sed -i 's@fstat64@fstat@g' ${SRC}/sock.c",

        ]
    }
}