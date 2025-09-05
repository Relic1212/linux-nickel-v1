{
  lib,
  drvs,

  seatd | lib.MesonPackage = {
    singleSource = {
      # uri = "https://git.sr.ht/~kennylevinsen/seatd/archive/0.8.0.tar.gz",
      # sha256sum = "a562a44ee33ccb20954a1c1ec9a90ecb2db7a07ad6b18d0ac904328efbcf65a0",

      uri = "https://git.sr.ht/~kennylevinsen/seatd/archive/0.9.1.tar.gz",
      sha256sum = "819979c922a0be258aed133d93920bce6a3d3565a60588d6d372ce9db2712cd3"
    },
    biDrvs = [
      # drvs.linuxHeadersStage0,
      drvs.linuxHeaders,
      drvs.scdoc,
      # drvs.elogind,
    ],
    propagatedBuildInputs = [
      drvs.elogindWithPolkit,
    ],
    # preConfigurePhase = [
    #   m%"
    #         fix_symbol(){
    #             for f in $(find ${SRC} -type f);do
    #                 sed -i "s@${1}(@${1}_libseat_reserved(@g" $f
    #                 sed -i "s@_${1}_libseat_reserved(@_${1}(@g" $f
    #             done
    #         }
    #         fix_symbol "list_insert"
    #         fix_symbol "seat_create"
    #         fix_symbol "seat_destroy"
    #         fix_symbol "server_init"
    #         fix_symbol "server_finish"
    #         "%,
    #   "sed -i 's@-Wl,--exclude-libs=ALL@@g' ${SRC}/meson.build"
    # ],

    buildEnv.CFLAGS = (lib.MesonPackage.buildEnv.CFLAGS) @ ["-Wno-sign-compare"],
    buildEnv.LDFLAGS = (lib.MesonPackage.buildEnv.LDFLAGS) @ ["-Wno-error=unused-command-line-argument"],

    extraMesonArgs = [
      # "-Dlibseat-builtin=enabled",
      # "-Dserver=enabled",
      # "-Dserver=disabled",
      # "-Dlibseat-seatd=enabled",

      # "-Dlibseat-seatd=disabled",
      # "-Dserver=disabled",
      # "-Dlibseat-builtin=disabled",
      "-Dlibseat-logind=elogind",
      "-Dman-pages=enabled",
    ],
    # baseMesonArgs = lib.constants.mesonArgsDebug @ lib.constants.mesonArgsStatic,
  }
}
