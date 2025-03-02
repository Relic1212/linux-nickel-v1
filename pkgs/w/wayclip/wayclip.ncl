{
    lib,
    drvs,
    wayclip|lib.MakePackage = {
        singleSource = {
            uri = "https://git.sr.ht/~noocsharp/wayclip/archive/0.4.2.tar.gz",
            sha256sum = "2a557e5bc713fdc64da5d957001f05330afbc88b2c59bef056623cfd2809816d"
        },
        biDrvs = [
            drvs.wayland,
            drvs.waylandProtocols,
            drvs.libffi,

        ],
        buildEnv = {
            EXTRA_LDFLAGS = [
                "-lffi"
            ]
        },
        extraMakeArgs=[
            "LIB=' -lffi -lwayland-client'"
        ]
    }
}