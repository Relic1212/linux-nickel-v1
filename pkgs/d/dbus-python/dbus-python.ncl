{
    lib,
    drvs,

    dbusPython | lib.MesonPackage = {
        singleSource = {
            uri = "https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.3.2.tar.gz",
            sha256sum = "1"
        }
    }
}