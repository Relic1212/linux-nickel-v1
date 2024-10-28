{
    lib,
    skalibs|lib.AutotoolsPackage={
        singleSource={
            uri="https://skarnet.org/software/skalibs/skalibs-2.14.3.0.tar.gz",
            sha256sum="a14aa558c9b09b062fa16acec623b2c8f93d69f5cba4d07f6d0c58913066c427",
        },
        extraConfigureFlags=[
            # https://skarnet.org/software/skalibs/crosscompile.html
            "--with-sysdep-devurandom",
            "--with-sysdep-posixspawnearlyreturn",
            
        ],
        separateBuildDir=false,
    }
}