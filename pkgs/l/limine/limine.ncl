{
    lib,
    drvs,
    limine|lib.AutotoolsPackage={
        singleSource = {
            uri = "https://github.com/limine-bootloader/limine/releases/download/v9.2.1/limine-9.2.1.tar.xz",
            sha256sum = "0e13ceab7514c7d7a7a60bad8f20884f82bb4c00b093aaa8187d92c233b95cb3"
        },
        extraConfigureFlags=[
            "--enable-uefi-x86-64",

        ],
        # extraMakeTargets=[
        #     "limine-uefi-x86-64"
        # ],
        biDrvs=[
            drvs.nasm,
            drvs.mtools,
        ]
    }
}