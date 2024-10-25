{
  lib,
  _libsspNonsharedBase | lib.Package
    = {
      stage,
      baseName = "libssp-nonshared",
      singleSource = {
        uri = "https://raw.githubusercontent.com/alpinelinux/aports/1177d1af7808fcec67822aa569e0ee1eb427cd32/main/musl/__stack_chk_fail_local.c",
        sha256sum = "299a7d75a09de3e2e11e7fb4acc3182e4a14e868093d2f30938fce9bfcff13da",
      },

      buildPhase = [
        "echo CC=${CC}",
        # "which lld",
        # "which ld.lld",
        # "export LIBDIR=${LIBDIR}:/usr/lib:/lib",
        (
          let f = if (stage == 0) then " -L/tmp/workdir/sysroot/usr/lib -L/usr/lib/ -L/tmp/workdir/sysroot/usr/lib" else "" in
          "CMD=\"${CC} -c %{f}${CFLAGS} ${LDFLAGS} /tmp/workdir/src/__stack_chk_fail_local.c -o a.out\""
        ),
        "echo \"running ${CMD}\"",
        "${CMD}",
        "echo \"running ar\"",
        "${AR} r libssp_nonshared.a a.out"
      ],
      installPhase = [
        "install -d -m0755 ${DEST}/usr/lib",
        "install -m0755 libssp_nonshared.a ${DEST}/usr/lib",
      ]
    },
  llvmBaselibsStage0,
  muslStage0,
  libsspNonsharedStage0 =
    _libsspNonsharedBase
    & {
      stage = 0,
      buildInputs =
        lib.biMap [
          llvmBaselibsStage0,
          muslStage0
        ],
      buildEnv =
        _libsspNonsharedBase.buildEnv
        & {
          CFLAGS | priority 10 = _libsspNonsharedBase.buildEnv.CFLAGS @ ["--sysroot=/tmp/workdir/sysroot"],

          LDFLAGS | priority 10 = (lib.functions.replaceArrayElem "-fuse-ld=lld" "-fuse-ld=/tmp/workdir/sysroot/usr/bin/ld.lld" _libsspNonsharedBase.buildEnv.LDFLAGS),
        },
    }
}
