{
    lib,
    drvs,
    metalog|lib.AutomakePackage={
        singleSource={
            uri="https://github.com/hvisage/metalog/archive/refs/tags/metalog-20230719.tar.gz",
            sha256sum="563b41409ee9e396c3709f002b59ccd9aff901b7d7e3adee6344e4b599a02105",
        },
        # singleSource={
        #     uri="https://github.com/hvisage/metalog/archive/refs/tags/metalog-20220214.tar.gz",
        #     sha256sum="3a9dd6f1460d90296771c81aa71fc0f45dd25ef22af63f48e6cbe5422a88f3bf",
        # },
        biDrvs=[
            drvs.pcre2,
         ],
         utilsProviders =
         [
          drvs.bash,
          drvs.coreutils,
          drvs.bashSh,
           drvs.samurai,
           
        ],
        patches=[{
            file="metalog.patch",
            sha256sum="7f0350ad38865bd153e90f1bf094f77f89fc4dbdf04c68ac2a8add34bab50544",
        },
        ],

        # configurePhase=[
        #     "cd ${SRC}",
        #     "autoconf -fi",
        #     "./configure",
        # ]
    }
}