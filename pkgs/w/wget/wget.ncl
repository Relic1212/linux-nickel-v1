{
    lib,
    drvs,
    wget | lib.AutotoolsPackage = {
        singleSource = {
            uri="https://ftp.wayne.edu/gnu/wget/wget2-2.1.0.tar.gz",
            sha256sum ="a05dc5191c6bad9313fd6db2777a78f5527ba4774f665d5d69f5a7461b49e2e7"
        },
        biDrvs = [
            drvs.ncurses, 
            drvs.readline,
            drvs.openssl,
            drvs.pkgconf,
            drvs.linuxHeaders
        ]
    }
}