{
    lib,
    drvs,
    libmpdclient | lib.MesonPackage = {
        singleSource = {
            uri ="https://github.com/MusicPlayerDaemon/libmpdclient/archive/refs/tags/v2.23.tar.gz",
            sha256sum = "e111bb0f112cdb13e531e7e2e0888b45caf486ab0dfdf33a098d15e15962e7a4"
        },
        biDrvs = [
            drvs.linuxHeaders
        ]
    }
}