{
    lib,
    drvs,
    xdgUtils | lib.AutotoolsPackage = {
        separateBuildDir = false,
        singleSource = {
            uri = "https://gitlab.freedesktop.org/xdg/xdg-utils/-/archive/v1.2.1/xdg-utils-v1.2.1.tar.gz",
            sha256sum = "f6b648c064464c2636884c05746e80428110a576f8daacf46ef2e554dcfdae75"
        },
        biDrvs = [
            drvs.libxslt,
        ]
    }
}