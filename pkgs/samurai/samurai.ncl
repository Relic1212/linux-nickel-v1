let lib = import "../../nickellib/lib.ncl"
in

let _samurai | lib.MakePackage
  =
    let _makeInstallArgs = lib.MakePackage.makeInstallArgs @ ["PREFIX=/usr"] in
    {
      baseName = "samurai",
      sourceInputs = [
        {
          src = {
            uri = "https://github.com/michaelforney/samurai/archive/189023533035ecc30848ba8dffc25c9139928f89.zip",
            sha256sum = "acb644c29b78a3c50aba8cc636b7ccde0e9c7a40c89d70d59a3604fed2187c62",
          }
        }
      ],
      buildDir = "${SRC}",
      makeInstallArgs = _makeInstallArgs,
      installPhase =
        (lib.MakePackage & { makeInstallArgs = _makeInstallArgs }).installPhase
        @ [
          "cd ${DEST}/usr/bin",
          "ln -s samu ninja",
        ],
    }
  in
{
  muslStage1,
  busyboxStage0,
  llvmStage0,
  ccacheBin,
  gnumakeStage1,

  samuraiStage1 =
    _samurai
    & {
      stage = 1,
      buildInputs =
        lib.biMap [
          busyboxStage0,
          muslStage1,
          llvmStage0,
          ccacheBin,
          gnumakeStage1
        ]
    },
#   muslStage0,
#   samuraiStage0 =
#     _samurai
#     & {
#       stage = 0,
#       buildEnv | priority 1
#         =
#           let flags = [
#             "-nostdlib",
#             "-nostdinc",
#             "--sysroot=/tmp/workdir/sysroot",
#             "-I/tmp/workdir/sysroot/usr/include"
#           ]
#           in
#           _samurai.buildEnv
#           & {
#             CFLAGS | priority 1
#               =
#                 _samurai.buildEnv.CFLAGS @ flags,
#             CPPFLAGS | priority 1
#               =
#                 (if (std.record.has_field "CPPFLAGS" _samurai.buildEnv) then _samurai.buildEnv.CPPFLAGS else [])
#                 @ flags,
#             LDFLAGS | priority 1 = _samurai.buildEnv.LDFLAGS @ [
#      "-nostdlib",
#             "-nostdinc",
#             "--sysroot=/tmp/workdir/sysroot",
#             "-L/tmp/workdir/sysroot/usr/lib",
#             "-lc",
#             ],
#           },
#       buildInputs =
#         lib.biMap [
#           muslStage0
#         ]
#     }
}
