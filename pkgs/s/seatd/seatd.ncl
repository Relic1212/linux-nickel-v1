{
    lib,pkgs,

    seatd|lib.MesonPackage={
        name="seatd",
        singleSource={
            uri="https://git.sr.ht/~kennylevinsen/seatd/archive/0.8.0.tar.gz",
            sha256sum="a562a44ee33ccb20954a1c1ec9a90ecb2db7a07ad6b18d0ac904328efbcf65a0",

        },
        biPkgs=[
            pkgs.linuxHeadersStage0,
        ],
        preConfigurePhase=[
            m%"
            fix_symbol(){
                for f in $(find ${SRC} -type f);do
                    sed -i "s@${1}(@${1}_libseat_reserved(@g" $f
                    sed -i "s@_${1}_libseat_reserved(@_${1}(@g" $f
                done
            }
            fix_symbol "list_insert"
            fix_symbol "seat_create"
            fix_symbol "seat_destroy"
            fix_symbol "server_init"
            fix_symbol "server_finish"
            "%,

            "sed -i 's@-Wl,--exclude-libs=ALL@@g' ${SRC}/meson.build"
        ],

        buildEnv.CFLAGS=(lib.MesonPackage.buildEnv.CFLAGS) @ [ "-Wno-sign-compare"],
        buildEnv.LDFLAGS=(lib.MesonPackage.buildEnv.LDFLAGS) @ [ "-Wno-error=unused-command-line-argument"],


    }
}