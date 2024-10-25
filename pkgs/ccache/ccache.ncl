
{
    # busybox,
    lib,
    pkgs,
    ccache|lib.CmakePackage={
        name="ccache",
        singleSource={
            uri="https://github.com/ccache/ccache/releases/download/v4.10.2/ccache-4.10.2.tar.xz",
        sha256sum="c0b85ddfc1a3e77b105ec9ada2d24aad617fa0b447c6a94d55890972810f0f5a",
        },
        # buildInputs=[],
        enableCcache=false,
        generator="Ninja",
        biPkgs=[
             pkgs.samurai,pkgs.llvm 
        ]
    }
}