{
    lib,
    drvs,
    j4MenuDesktop | lib.MesonPackage = {
        singleSource = {
            uri = "https://github.com/enkore/j4-dmenu-desktop/archive/refs/tags/r3.1.tar.gz",
            sha256sum = "0e6cf25663cc220e3e3e2bc013fe957c3e4a44f900b5ee6a7609cd501021652d"
        },
        biDrvs = [
            drvs.fmt,
            drvs.spdlog,
            drvs.catch2,
            drvs.crazyComplete,
        ]
    }
}
&
{
    lib,
    drvs,
    fmt | lib.CmakePackage = {
        generator = "Ninja",
        singleSource ={
            # uri = "https://github.com/fmtlib/fmt/archive/df249d8ad3a9375f54919bdfa10a33ae5cba99a2.zip",
            # sha256sum = "703a9eeb5282b105e739e7d47b4c4844ef030d2c58732dc70f9a225fc79051db"

            uri = "https://github.com/fmtlib/fmt/archive/6e462b89aa22fd5f737ed162d0150e145ccb1914.zip",
            sha256sum = "b2a1b1ddf272b1c8836a46412677fa5918c76732c07baf23c768f06968a49782"
        }
    }
}
&
{
    lib,
    drvs,
    spdlog | lib.CmakePackage = {
        generator = "Ninja",
        singleSource ={
            uri = "https://github.com/gabime/spdlog/archive/refs/tags/v1.15.0.tar.gz",
            sha256sum = "9962648c9b4f1a7bbc76fd8d9172555bad1871fdb14ff4f842ef87949682caa5"
        }
    }
}

&

{
    lib,
    drvs,
    catch2 | lib.MesonPackage = {
        singleSource = {
            uri ="https://github.com/catchorg/Catch2/archive/refs/tags/v3.7.1.tar.gz",
            sha256sum = "c991b247a1a0d7bb9c39aa35faf0fe9e19764213f28ffba3109388e62ee0269c"
        }
    }
}

&

{
    lib,
    drvs,

    crazyComplete | lib.SetuptoolPackage = {
        singleSource = {
            uri = "https://github.com/crazy-complete/crazy-complete/archive/refs/tags/0.3.2.tar.gz",
            sha256sum = "99ae5b7bcb281d901516e4dc10f3dfa4d82cb4f02cdb80baa3dcef402c1e4653"
        }
    }
}