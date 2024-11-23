{
    lib,
    drvs,
    vim | lib.AutotoolsPackage = {
        singleSource = {
            uri = "https://github.com/vim/vim/archive/refs/tags/v9.1.0882.tar.gz",
            sha256sum ="1afe43512380c3d278f8b627fde76bae6a3791a0e9cf7864551cc2843b525f0b"
        },
        separateBuildDir = false,
        biDrvs = [
            drvs.ncurses,
            drvs.readline,
        ]
    }
}