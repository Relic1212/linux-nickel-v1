{
    lib,
    drvs,
    wtype | lib.MesonPackage = {
        singleSource ={uri = "https://github.com/atx/wtype/archive/refs/tags/v0.4.tar.gz",
        sha256sum = "da91786d828b6a6e29b884bc510473939eda052658ebef87d7bdeafa6a8746f9"
        },
        biDrvs = [
            drvs.wayland,
            drvs.libxkbcommon,
            drvs.linuxHeaders,
            drvs.libffi,
        ]
    }
}